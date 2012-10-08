require File.dirname(__FILE__) + '/../test_helper'

class PlannerControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles

  setup do
    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_view
    Project.find(1).enabled_module_names = [:planner]
  end

  test "should get index" do
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'

    teams = assigns(:teams)
    assert teams
    teams.each do |team|
      assert team.is_a?(PlanGroup)
      assert_equal PlanGroup::TYPE_TEAM, team.group_type
    end

    groups = assigns(:groups)
    assert groups
    groups.each do |group|
      assert group.is_a?(PlanGroup)
      assert_equal PlanGroup::TYPE_GROUP, group.group_type
    end
  end

  test "should deny index" do
    @request.session[:user_id] = 3
    get :index, :project_id => 1

    assert_response 403
  end
end
