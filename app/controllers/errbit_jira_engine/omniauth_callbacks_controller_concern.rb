require 'active_support/concern'

module ErrbitJiraEngine::OmniauthCallbacksControllerConcern
  extend ActiveSupport::Concern
  
  included do
    def jira
      jira_email = env['omniauth.auth'].info.email
      jira_user = User.where(jira_uid: jira_email).first
      jira_site_title = Errbit::Config.jira_site_title

      if current_user
        if jira_user && jira_user != current_user
          flash[:error] = "User already registered with #{jira_site_title} login '#{jira_email}'!"
          redirect_to user_path(current_user)
        else
          current_user.set_jira_authorisation!(env['omniauth.auth'])
          redirect_to user_path(current_user)
        end
      elsif jira_user
        flash[:success] = I18n.t "devise.omniauth_callbacks.success", kind: jira_site_title
        jira_user.set_jira_authorisation!(env['omniauth.auth'])

        sign_in_and_redirect jira_user, event: :authentication
      else
        flash[:error] = "There are no authorized users with #{jira_site_title} login '#{jira_email}'. Please ask an administrator to register your user account."
        redirect_to new_user_session_path
      end
    end
  end
end
