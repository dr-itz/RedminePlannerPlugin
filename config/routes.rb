RedmineApp::Application.routes.draw do
  match 'projects/:project_id/planner', :to => 'planner#index'
end
