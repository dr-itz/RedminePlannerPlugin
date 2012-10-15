require File.dirname(__FILE__) + '/../test_helper'

class PlanChartsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles,
    :plan_requests, :plan_details

  setup do
    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_view
    Project.find(1).enabled_module_names = [:planner]
  end

  test "should deny show_user" do
    @request.session[:user_id] = 3
    get :show_user, :project_id => 1, :id => 3

    assert_response 403
  end

  test "should deny show_group" do
    @request.session[:user_id] = 3
    get :show_group, :project_id => 1, :id => 3

    assert_response 403
  end

  test "should get show_user defaults" do
    get :show_user, :project_id => 1, :id => 3

    assert_response :success

    user = assigns(:user)
    assert user
    assert_equal 3, user.id

    chart = assigns(:chart)
    assert chart
    assert_equal 8, chart.data[0].length
    assert_equal 8, chart.ticks.length
    # hint: can't assert on data: moving date window - too complicated with fixtures

    date = Date.today - 7
    date = Date.commercial(date.cwyear, date.cweek, 1)
    assert_equal date, assigns(:start_date)
    assert_equal 8, assigns(:num_weeks)
  end

  test "should get show_user user settings" do
    get :show_user, :project_id => 1, :id => 3, :week_start_date => '2012-9-19', :num_weeks => 10

    assert_response :success

    user = assigns(:user)
    assert user
    assert_equal 3, user.id

    chart = assigns(:chart)
    assert chart
    assert_equal 2, chart.data.length
    assert_equal 10, chart.data[0].length
    assert_equal 10, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal Date.parse('2012-9-17'), assigns(:start_date)
    assert_equal 10, assigns(:num_weeks)
  end

  test "should get show_user user settings XHR" do
    xhr :get, :show_user, :project_id => 1, :id => 3, :week_start_date => '2012-9-19', :num_weeks => 6

    assert_response :success
    assert_equal 'text/javascript', response.content_type

    assert_equal 3, assigns(:user).id
    assert assigns(:chart)

    assert_include '#user-chart-display', response.body
    assert_include '#week_start_date', response.body
    assert_include '2012-09-17', response.body
    assert_include "jqplot(\\'chartUser\\', [[60,80,0,0,0,0],[0,0,0,70,50,0]]", response.body
    assert_include 'Req. #2: Task 2', response.body
    assert_include 'Req. #3: Task 2', response.body
    assert_include 'ticks: [\"2012-38\",\"2012-39\",\"2012-40\",\"2012-41\",\"2012-42\",\"2012-43\"]', response.body
  end

  test "should get show_group defaults" do
    get :show_group, :project_id => 1, :id => 1

    assert_response :success

    group = assigns(:group)
    assert group.is_a?(PlanGroup)
    assert_equal 1, group.id

    chart = assigns(:chart)
    assert chart
    assert_equal 8, chart.data[0].length
    assert_equal 8, chart.ticks.length
    # hint: can't assert on data: moving date window - too complicated with fixtures

    date = Date.today - 7
    date = Date.commercial(date.cwyear, date.cweek, 1)
    assert_equal date, assigns(:start_date)
    assert_equal 8, assigns(:num_weeks)
  end

  test "should get show_group user settings" do
    get :show_group, :project_id => 1, :id => 1, :week_start_date => '2012-9-19', :num_weeks => 10

    assert_response :success

    group = assigns(:group)
    assert group.is_a?(PlanGroup)
    assert_equal 1, group.id

    chart = assigns(:chart)
    assert chart
    assert_equal 2, chart.data.length
    assert_equal 10, chart.data[0].length
    assert_equal 10, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal Date.parse('2012-9-17'), assigns(:start_date)
    assert_equal 10, assigns(:num_weeks)
  end

  test "should get show_group user settings XHR" do
    xhr :get, :show_group, :project_id => 1, :id => 1, :week_start_date => '2012-9-19', :num_weeks => 6

    assert_response :success
    assert_equal 'text/javascript', response.content_type

    assert_equal 1, assigns(:group).id
    assert assigns(:chart)

    assert_include '#group-chart-display', response.body
    assert_include '#week_start_date', response.body
    assert_include '2012-09-17', response.body
    assert_include "jqplot(\\'chartGroup\\', [[60,80,0,70,50,0],[60,0,0,0,0,0]]", response.body
    assert_include 'John Smith', response.body
    assert_include 'Dave Lopper', response.body
    assert_include 'ticks: [\"2012-38\",\"2012-39\",\"2012-40\",\"2012-41\",\"2012-42\",\"2012-43\"]', response.body
  end
end
