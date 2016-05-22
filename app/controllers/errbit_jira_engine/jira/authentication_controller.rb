module Jira
  class AuthenticationController < ApplicationController
    before_action { session[:jira] ||= {} }
    
    def initiate
      request_token = jira_client.request_token(oauth_callback: jira.jira_finalise_url)

      session[:jira]['request_token'] = request_token.token
      session[:jira]['request_token_secret'] = request_token.secret
      
      redirect_to request_token.authorize_url
    end
    
    def finalise
      request_token = get_request_token
      return unless request_token
      
      access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
      current_user.jira_token = access_token.token
      current_user.jira_secret = access_token.secret
      current_user.save!
      
      if session[:jira] && session[:jira]['create_issue']
        redirect_to jira.resume_create_issue_path
      else
        redirect_to main_app.user_path(current_user)
      end
    ensure
      session[:jira].delete('request_token')
      session[:jira].delete('request_token_secret')
    end
    
    private
    
    def jira_client
      @jira_client ||= ErrbitJiraEngine.create_client
    end
    
    def get_request_token
      return @request_token if @request_token
      
      token = session[:jira]['request_token']
      secret = session[:jira]['request_token_secret']
      
      if token.present? && secret.present?
        @request_token = jira_client.set_request_token(token, secret)
      else
        redirect_to jira.jira_initiate_path
      end
      
      @request_token
    end
  end
end