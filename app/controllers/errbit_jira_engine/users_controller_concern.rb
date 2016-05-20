require 'active_support/concern'

module ErrbitJiraEngine::UsersControllerConcern
  extend ActiveSupport::Concern

  def unlink_jira
    user.update(jira_uid: nil, jira_token: nil, jira_secret: nil, jira_expires_at: nil)
    redirect_to user_path(user)
  end
end
