ErrbitJiraEngine::Engine.routes.draw do
  namespace :jira do
    get 'initiate' => 'authentication#initiate'
    get 'finalise' => 'authentication#finalise'
  end
  
  scope path: '/apps/:app_id' do
    get 'resume_create_issue' => 'problems#resume_create_issue', as: :resume_create_issue
  end

  scope path: '/users/:id' do
    delete :unlink_jira, controller: 'users'
  end
end
