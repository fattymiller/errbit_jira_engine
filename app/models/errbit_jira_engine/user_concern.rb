require 'active_support/concern'

module ErrbitJiraEngine::UserConcern
  extend ActiveSupport::Concern

  included do
    field :jira_uid
    field :jira_token
    field :jira_secret
    field :jira_expires_at
  end
  
  def set_jira_authorisation!(auth_hash)
    self.jira_uid = auth_hash.info.email
    self.jira_token = auth_hash.credentials['token']
    self.jira_secret = auth_hash.credentials['secret']
    self.jira_expires_at = Time.at(auth_hash.credentials['expires_at']) if auth_hash.credentials['expires_at']
    
    save!
  end
  
  def password_required?
    jira_token.present? ? false : super
  end
  
  def jira_account?
    jira_uid.present?
  end
  
  def jira_authorisation_current?
    !!jira_expires_at && jira_expires_at > Time.now
  end
end
