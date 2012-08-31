require File.dirname(__FILE__) + '/../test_helper'

class PlannerControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles

  def setup
    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_view
    Project.find(1).enabled_module_names = [:planner]
  end

  def test_index
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'
  end

  def test_index_no_permission
    @request.session[:user_id] = 3
    get :index, :project_id => 1

    assert_response 403
  end
end
