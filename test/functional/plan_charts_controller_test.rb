require File.dirname(__FILE__) + '/../test_helper'

class PlanChartsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles,
    :plan_requests, :plan_details

  include PlannerHelper

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

  test "should deny show_task" do
    @request.session[:user_id] = 3
    get :show_task, :project_id => 1, :id => 3

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
    assert_equal date, assigns(:chart).start_date
    assert_equal 8, assigns(:chart).weeks
  end

  test "should get show_user user settings" do
    get :show_user, :project_id => 1, :id => 3,
      :start => '2012-9-19', :weeks => 10, :inc_new => "1"

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
    assert_equal 2, chart.series_details.length

    assert_equal Date.parse('2012-9-17'), assigns(:chart).start_date
    assert_equal 10, assigns(:chart).weeks
  end

  test "should get show_user user settings XHR" do
    xhr :get, :show_user, :project_id => 1, :id => 3,
      :start => '2012-9-19', :weeks => 6, :inc_new => "1"

    assert_response :success
    assert_equal 'text/javascript', response.content_type

    assert_equal 3, assigns(:user).id
    chart = assigns(:chart)
    assert chart
    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length
    assert_equal 2, chart.series_details.length

    assert_include '#user-chart-display', response.body
    assert_include '#start', response.body
    assert_include '#weeks', response.body
    assert_include '2012-09-17', response.body
    assert_include "data: [[60,80,0,60,0,0],[0,0,0,70,50,0]]", response.body
    assert_include 'Req. #2 (John Smith)', response.body
    assert_include 'Task 2', response.body
    assert_include 'Req. #3 (Dave Lopper)', response.body
    assert_include 'xWeekTicks: [\"W38\",\"W39\",\"W40\",\"W41\",\"W42\",\"W43\"]', response.body
    assert_include 'threshold_data: [[[', response.body
  end

  test "should get show_user limit 52 weeks" do
    get :show_user, :project_id => 1, :id => 3, :start => '2012-9-19', :weeks => 77

    assert_response :success

    chart = assigns(:chart)
    assert chart
    assert_equal 52, chart.weeks
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
    assert_equal date, assigns(:chart).start_date
    assert_equal 8, assigns(:chart).weeks
  end

  test "should get show_group user settings" do
    get :show_group, :project_id => 1, :id => 1, :start => '2012-9-19', :weeks => 10

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
    assert_equal 2, chart.series_details.length
    assert chart.series_details[0].is_a?(User)
    assert_equal 3, chart.series_details[0].id
    assert chart.series_details[1].is_a?(User)
    assert_equal 2, chart.series_details[1].id

    assert_equal Date.parse('2012-9-17'), assigns(:chart).start_date
    assert_equal 10, assigns(:chart).weeks
  end

  test "should get show_group user settings XHR" do
    xhr :get, :show_group, :project_id => 1, :id => 1,
      :start => '2012-9-19', :weeks => 6, :inc_new => "1"

    assert_response :success
    assert_equal 'text/javascript', response.content_type

    assert_equal 1, assigns(:group).id
    chart = assigns(:chart)
    assert chart
    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length
    assert_equal 2, chart.series_details.length
    assert chart.series_details[0].is_a?(User)
    assert_equal 3, chart.series_details[0].id
    assert chart.series_details[1].is_a?(User)
    assert_equal 2, chart.series_details[1].id

    project = assigns(:project)
    assert project
    assert project.is_a?(Project)

    assert_include '#group-chart-display', response.body
    assert_include '#start', response.body
    assert_include '#weeks', response.body
    assert_include '2012-09-17', response.body
    assert_include "data: [[60,80,0,130,50,0],[60,0,0,0,0,0]]", response.body
    assert_include 'John Smith', response.body
    assert_include 'Dave Lopper', response.body
    assert_include 'xWeekTicks: [\"W38\",\"W39\",\"W40\",\"W41\",\"W42\",\"W43\"]', response.body
    assert_include 'threshold_data: [[[', response.body
  end

  test "should get show_group limit 52 weeks" do
    get :show_group, :project_id => 1, :id => 1, :start => '2012-9-19', :weeks => 77

    assert_response :success

    chart = assigns(:chart)
    assert chart
    assert_equal 52, chart.weeks
  end

  test "should get show_task defaults" do
    get :show_task, :project_id => 1, :id => 2

    assert_response :success

    assert_equal 2, assigns(:task).id
    chart = assigns(:chart)
    assert chart
    assert_equal 8, chart.data[0].length
    assert_equal 8, chart.ticks.length
    # hint: can't assert on data: moving date window - too complicated with fixtures

    date = Date.today - 7
    date = Date.commercial(date.cwyear, date.cweek, 1)
    assert_equal date, assigns(:chart).start_date
    assert_equal 8, assigns(:chart).weeks
  end

  test "should get show_task user settings" do
    get :show_task, :project_id => 1, :id => 2,
      :start => '2012-9-19', :weeks => 10, :inc_new => "1"

    assert_response :success

    assert_equal 2, assigns(:task).id

    chart = assigns(:chart)
    assert chart
    assert_equal 4, chart.data.length
    assert_equal 10, chart.data[0].length
    assert_equal 10, chart.ticks.length
    assert_equal 4, chart.series.length
    assert_equal 4, chart.series_details.length

    assert_equal Date.parse('2012-9-17'), assigns(:chart).start_date
    assert_equal 10, assigns(:chart).weeks
  end

  test "should get show_task user settings XHR" do
    xhr :get, :show_task, :project_id => 1, :id => 2,
      :start => '2012-9-19', :weeks => 6, :inc_new => "1"

    assert_response :success
    assert_equal 'text/javascript', response.content_type

    assert_equal 2, assigns(:task).id
    chart = assigns(:chart)
    assert chart
    assert_equal 4, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 4, chart.series.length
    assert_equal 4, chart.series_details.length

    assert_include '#task-chart-display', response.body
    assert_include '#start', response.body
    assert_include '#weeks', response.body
    assert_include '2012-09-17', response.body
    assert_include "data: [[60,0,0,0,0,0],[60,80,0,60,0,0],[0,0,0,70,50,0],[0,0,0,60,0,0]]", response.body
    assert_include 'Req. #2 (John Smith)', response.body
    assert_include 'Req. #3 (Dave Lopper)', response.body
    assert_include 'xWeekTicks: [\"W38\",\"W39\",\"W40\",\"W41\",\"W42\",\"W43\"]', response.body
    assert_include 'threshold_data: [[[', response.body
  end
end
