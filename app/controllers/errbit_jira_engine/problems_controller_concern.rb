require 'active_support/concern'

module ErrbitJiraEngine::ProblemsControllerConcern
  extend ActiveSupport::Concern

  def create_issue
    issue_tracker = app.issue_tracker
  
    if issue_tracker && issue_tracker.is_a?(ErrbitJiraEngine::IssueTracker)
      unless current_user.jira_authorisation_current?
        session[:jira] ||= {}
        session[:jira][:create_issue] = problem.id
  
        return redirect_to(jira.jira_initiate)
      end
    end
    
    super
  end
end
