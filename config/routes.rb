RedmineApp::Application.routes.draw do
  match 'projects/:project_id/planner', :to => 'planner#index'

  resources :projects, :shallow => true do
    resources :plan_groups
    resources :plan_tasks
    resources :plan_requests do
      resources :plan_details
    end
  end

  match '/projects/:project_id/planner/settings',
    :to => 'planner_config#update', :via => :put,
    :as => 'planner_config'

  match '/plan_groups/:id/members/:membership_id',
    :to => 'plan_groups#remove_membership', :via => :delete,
    :as => 'plan_group_membership'
  match '/plan_groups/:id/members',
    :to => 'plan_groups#add_membership', :via => :post,
    :as => 'plan_group_memberships'

  match '/plan_requests/:id/request',
    :to => 'plan_requests#send_request', :via => :put,
    :as => 'plan_request_send_request'
  match '/plan_requests/:id/approve',
    :to => 'plan_requests#approve', :via => :put,
    :as => 'plan_request_approve'

  match '/projects/:project_id/planner/user/:id',
    :to => 'plan_charts#show_user', :via => :get,
    :as => 'planner_show_user'
  match '/projects/:project_id/planner/group/:id',
    :to => 'plan_charts#show_group', :via => :get,
    :as => 'planner_show_group'
  match '/projects/:project_id/planner/task/:id',
    :to => 'plan_charts#show_task', :via => :get,
    :as => 'planner_show_task'
end
