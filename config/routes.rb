ErrbitJiraEngine::Engine.routes.draw do
  namespace :jira do
    get 'initiate' => 'authentication#initiate'
    get 'finalise' => 'authentication#finalise'
  end

  scope path: '/users/:id' do
    delete :unlink_jira, controller: 'users'
  end
end
