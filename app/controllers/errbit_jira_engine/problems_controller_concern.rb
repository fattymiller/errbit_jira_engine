require 'active_support/concern'

module ErrbitJiraEngine::ProblemsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    before_action :ensure_authorised!, only: :create_issue    
  end
  
  private def ensure_authorised!
    issue_tracker = app.issue_tracker.try(:type).try(:object)
  
    if issue_tracker && issue_tracker <= ErrbitJiraEngine::IssueTracker && !current_user.jira_authorisation_current?
      session[:jira] ||= {}
      session[:jira][:create_issue] = problem.id

      return redirect_to(jira.jira_initiate)
    end
  end
end
