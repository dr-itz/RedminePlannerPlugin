require File.dirname(__FILE__) + '/../test_helper'

class PlanDetailsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles, :enabled_modules,
    :plan_tasks, :plan_requests, :plan_details

  setup do
    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_view
    Role.find(1).add_permission! :planner_admin
    Project.find(1).enabled_module_names = [:planner]
  end

  test "should get index" do
    get :index, :plan_request_id => 2

    assert_redirected_to plan_request_url(assigns(:plan_request))
  end

  test "should create plan_details" do
    post_create

    assert_equal 4, PlanRequest.find(2).details.length
    assert_redirected_to plan_request_url(assigns(:plan_request))
  end

  test "should deny create" do
    @request.session[:user_id] = 3

    post_create

    assert_response 403
  end

  test "should create plan_details XHR" do
    xhr :post, :create, :plan_request_id => 2, :plan_detail => {
      :week_start_date => "2012-09-24", :percentage => 70, :ok_mon => false, :ok_tue => false
    }, :num_week => 3

    assert_equal 4, PlanRequest.find(2).details.length
    assert_response :success
    assert_template 'refresh'
    assert_equal 'text/javascript', response.content_type
    assert_include 'detail-list', response.body
  end

  test "should destroy plan_details" do
    assert_difference('PlanDetail.count', -1) do
      delete :destroy, :id => 2
    end

    assert_redirected_to plan_request_url(assigns(:plan_request))
    assert !PlanDetail.exists?(2)
  end

  test "should destroy plan_details XHR" do
    assert_difference('PlanDetail.count', -1) do
      xhr :delete, :destroy, :id => 2
    end

    assert_response :success
    assert_template 'refresh'
    assert_equal 'text/javascript', response.content_type
    assert_include 'detail-list', response.body
    assert !PlanDetail.exists?(2)
  end

  test "should deny destroy" do
    @request.session[:user_id] = 3
    delete :destroy, :id => 2
    assert_response 403
  end

private
  def post_create
    post :create, :plan_request_id => 2, :plan_detail => {
      :week_start_date => "2012-09-24", :percentage => 70, :ok_mon => false, :ok_tue => false
    }, :num_week => 3
  end
end
