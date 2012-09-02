RedmineApp::Application.routes.draw do
  match 'projects/:project_id/planner', :to => 'planner#index'

  resources :projects, :shallow => true do
    resources :plan_groups
    resources :plan_tasks
  end
end
