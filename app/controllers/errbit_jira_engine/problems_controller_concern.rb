require 'active_support/concern'

module ErrbitJiraEngine::ProblemsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    before_action :ensure_authorised!, only: :create_issue    
  end
  
  def resume_create_issue
    params[:id] = session[:jira]['create_issue'].to_i    
    issue = IssueService.create_issue(self, problem, current_user) if problem    
    flash[:error] = issue.errors.full_messages.join(', ') if issue && issue.errors.any?
    
    redirect_to main_app.app_problem_path(app, problem)
  ensure
    session[:jira].delete('create_issue')
  end
  
  private def ensure_authorised!
    issue_tracker = app.issue_tracker.try(:type).try(:object)
  
    if issue_tracker && issue_tracker <= ErrbitJiraEngine::IssueTracker && !current_user.jira_authorisation_current?
      session[:jira] ||= {}
      session[:jira]['create_issue'] = problem.id

      return redirect_to(jira.jira_initiate_path)
    end
  end
end
