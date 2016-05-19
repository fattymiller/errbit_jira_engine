Rails.application.routes.draw do

  mount ErrbitJiraEngine::Engine => "/errbit_jira_engine"
end
