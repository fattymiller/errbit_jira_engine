module ErrbitJiraEngine
  class Engine < ::Rails::Engine
    engine_name :jira
    
    initializer 'config.jira.concerns' do
      decorate_classes
    end
    
    def decorate_classes
      ProblemsController.class_eval do
        include ErrbitJiraEngine::ProblemsControllerConcern
      end
      
      UsersController.class_eval do
        include ErrbitJiraEngine::UsersControllerConcern
      end
      
      Users::OmniauthCallbacksController.class_eval do
        include ErrbitJiraEngine::OmniauthCallbacksControllerConcern
      end
      
      User.class_eval do
        include ErrbitJiraEngine::UserConcern
      end
    end
  end
end
