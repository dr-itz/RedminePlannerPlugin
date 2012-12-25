require File.dirname(__FILE__) + '/../test_helper'

class PlannerConfigShowTest < ActionDispatch::IntegrationTest
  fixtures :projects, :roles, :members, :member_roles, :enabled_modules,
    :plan_configs

  setup do
    Role.find(1).add_permission! :planner_admin

    @project = Project.find(1)
    @project.enabled_module_names = [:planner]
  end

  test "should show settings" do
    log_user('jsmith', 'jsmith')
    get "/projects/1/settings/planner"

    assert_response 200
    assert_select "#config_workload_target"
    assert_select "#config_workload_threshold_ok"
    assert_select "#config_workload_threshold_overload"
    assert_select "#config_graph_weeks_past"
    assert_select "#config_graph_weeks"
  end
end
