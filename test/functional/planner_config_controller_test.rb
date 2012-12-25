require File.dirname(__FILE__) + '/../test_helper'

class PlannerConfigControllerTest < ActionController::TestCase
  fixtures :projects, :roles, :members, :member_roles, :enabled_modules,
    :plan_configs

  setup do
    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_admin

    @project = Project.find(1)
    @project.enabled_module_names = [:planner]
  end

  test "should update settings" do
    put :update, :project_id => @project, :config => {
      :workload_target => 120, :workload_threshold_ok => 100
    }

    assert_redirected_to :controller => 'projects',
      :action => "settings", :id => @project, :tab => 'planner'

    config = PlanConfig.project_config(@project.id)
    assert_equal 120, config[:workload_target].to_i
    assert_equal 100, config[:workload_threshold_ok].to_i
  end

  test "should deny unauthorized update" do
    Role.find(1).remove_permission! :planner_admin
    put :update, :project_id => @project

    assert_response 403
  end
end
