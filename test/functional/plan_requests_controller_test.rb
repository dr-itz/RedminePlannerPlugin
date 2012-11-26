require File.dirname(__FILE__) + '/../test_helper'

class PlanRequestsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :trackers, :members, :member_roles,
    :enabled_modules, :plan_tasks, :plan_requests

  setup do
    @plan_request = plan_requests(:two)

    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_view
    Role.find(1).add_permission! :planner_admin
    Project.find(1).enabled_module_names = [:planner]
  end

  test "should get index" do
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'

    assert_equal PlanRequest.all_open_requests_requester(1), assigns(:requests_requester)
    assert_equal PlanRequest.all_open_requests_approver(1), assigns(:requests_approver)
    assert_equal PlanRequest.all_open_requests_requestee(1), assigns(:requests_requestee)
  end

  test "should get new" do
    get :new, :project_id => 1

    assert_response :success
    assert_template 'new'
  end

  test "should deny get new" do
    @request.session[:user_id] = 3

    get :new, :project_id => 1

    assert_response 403
  end

  test "should create plan_request" do
    test_create_ok
  end

  test "should not create invalid" do
    PlanRequest.any_instance.stubs(:save).returns(false)
    post_create
    assert_template 'new'
  end

  test "should get new with planner_request role" do
    set_planner_requests

    get :new, :project_id => 1

    assert_response :success
    assert_template 'new'
  end

  test "should deny create" do
    @request.session[:user_id] = 3

    post_create

    assert_response 403
  end

  test "should create with planner_request role" do
    set_planner_requests
    test_create_ok
  end

  test "should show plan_request" do
    get :show, :id => @plan_request.id

    assert_response :success
    assert_template 'show'
    assert_equal @plan_request, assigns(:plan_request)
  end

  test "should get edit" do
    get :edit, :id => @plan_request.id

    assert_response :success
    assert_template 'edit'
    assert_equal @plan_request, assigns(:plan_request)
  end

  test "should deny edit" do
    @request.session[:user_id] = 3

    get :edit, :id => @plan_request.id

    assert_response 403
  end

  test "should get edit create_perm" do
    set_planner_requests
    get :edit, :id => 2

    assert_response :success
  end

  test "should get edit own" do
    set_no_permissions
    get :edit, :id => 2

    assert_response :success
  end

  test "should update plan_request" do
    test_update_ok
  end

  test "should not update invalid" do
    PlanRequest.any_instance.stubs(:update_attributes).returns(false)
    put_update
    assert_template 'edit'
  end

  test "should deny update" do
    @request.session[:user_id] = 3

    put_update

    assert_response 403
  end

  test "should update own" do
    set_no_permissions
    test_update_ok
  end

  test "should destroy plan_request" do
    assert_difference('PlanRequest.count', -1) do
      delete :destroy, :id => 2
    end
    assert_redirected_to project_plan_requests_url(assigns(:project))
  end

  test "should deny destroy plan_request" do
    @request.session[:user_id] = 3
    delete :destroy, :id => @plan_request.id
    assert_response 403
  end

  test "should send request" do
    put :send_request, :id => @plan_request.id

    assert_redirected_to plan_request_url(assigns(:plan_request))

    tmp = PlanRequest.find(@plan_request.id)
    assert_equal PlanRequest::STATUS_READY, tmp.status
    assert_equal User.find(1), tmp.approver
  end

  test "should not send request without teamleader" do
    put :send_request, :id => 7

    assert_template 'show'

    tmp = PlanRequest.find(7)
    assert_equal PlanRequest::STATUS_NEW, tmp.status
    assert_nil tmp.approver
  end

  test "should forbid send request" do
    put :send_request, :id => 1
    assert_response 403
  end

  test "should forbid approve" do
    put :approve, :id => 2
    assert_response 403
  end

  test "should approve request" do
    put :approve, :id => 3, :plan_request => {
      :status => PlanRequest::STATUS_APPROVED, :approver_notes => 'Notes'
    }

    assert_redirected_to plan_request_url(assigns(:plan_request))

    tmp = PlanRequest.find(3)
    assert_equal PlanRequest::STATUS_APPROVED, tmp.status
    assert_equal 'Notes', tmp.approver_notes
  end

private
  def set_no_permissions
    Role.find(1).remove_permission! :planner_admin
  end

  def set_planner_requests
    set_no_permissions
    Role.find(1).add_permission! :planner_requests
  end

  def post_create
    post :create, :project_id => 1, :plan_request => {
      :requester_id => @plan_request.requester_id,
      :resource_id => @plan_request.resource_id,
      :task_id => @plan_request.task_id,
      :description => 'Description',
      :status => PlanRequest::STATUS_NEW
    }
  end

  def test_create_ok
    assert_difference('PlanRequest.count') do
      post_create
    end

    assert_redirected_to plan_request_url(assigns(:plan_request))

    tmp = assigns(:plan_request)
    assert_equal 'Description', tmp.description
  end

  def put_update
    put :update, :id => @plan_request.id, :plan_request => {
      :description => 'New descr',
    }
  end

  def test_update_ok
    put_update

    assert_redirected_to plan_request_url(assigns(:plan_request))

    tmp = PlanRequest.find(@plan_request.id)
    assert_equal 'New descr', tmp.description
  end
end
