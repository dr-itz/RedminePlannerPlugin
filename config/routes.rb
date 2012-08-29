RedmineApp::Application.routes.draw do
  match 'projects/:id/planner', :to => 'planner#index'
end
