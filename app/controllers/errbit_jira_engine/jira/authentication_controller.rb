module Jira
  class AuthenticationController < ApplicationController
    before_action { session[:jira] ||= {} }
    
    def initiate
      request_token = jira_client.request_token(oauth_callback: jira.jira_finalise_url)
      session[:jira][:request_token] = request_token.token
      session[:jira][:request_token_secret] = request_token.secret
      
      redirect_to request_token.authorize_url
    end
    
    def finalise
      request_token = get_request_token
      return unless request_token
      
      access_token = request_token.init_access_token(oauth_verifier: params[:oauth_verifier])
      current_user.jira_token = access_token.token
      current_user.jira_secret = access_token.secret
      current_user.save!
      
      if session[:jira] && (problem_id = session[:jira][:create_issue])
        problem = Problem.find(problem_id)
        issue = IssueService.create_issue(self, problem, current_user) if problem
        
        if issue
          flash[:error] = issue.errors.full_messages.join(', ') unless issue.valid?
          return redirect_to(main_app.app_problem_path(problem.app, problem))
        end
      end

      redirect user_path(current_user)
    ensure
      session[:jira] = nil
    end
    
    private
    
    def jira_client
      @jira_client ||= ErrbitJiraEngine.create_client
    end
    
    def get_request_token
      return @request_token if @request_token
      
      token = session[:jira][:request_token]
      secret = session[:jira][:request_token_secret]
      
      if token.present? && secret.present?
        @request_token = jira_client.set_request_token(token, secret)
      else
        redirect_to jira.jira_initiate_path
      end
      
      @request_token
    end
  end
end