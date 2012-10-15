require File.dirname(__FILE__) + '/../test_helper'

class PlanTasksControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :trackers, :members, :member_roles,
    :enabled_modules, :plan_tasks

  setup do
    @plan_task = plan_tasks(:two)

    @request.session[:user_id] = 2
    Role.find(1).add_permission! :planner_admin
    Project.find(1).enabled_module_names = [:planner]
  end

  test "should get index" do
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'
    assert_equal PlanTask.all_project_tasks(1), assigns(:plan_tasks)
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

  test "should create plan_task" do
    test_create_ok
  end

  test "should get new with task_create role" do
    set_create_only

    get :new, :project_id => 1

    assert_response :success
    assert_template 'new'
  end

  test "should not create invalid" do
    PlanTask.any_instance.stubs(:save).returns(false)
    post_create
    assert_template 'new'
  end

  test "should deny create" do
    @request.session[:user_id] = 3

    post_create

    assert_response 403
  end

  test "should create with task_create role" do
    set_create_only
    test_create_ok
  end

  test "should show plan_task" do
    get :show, :id => @plan_task.id

    assert_response :success
    assert_template 'show'
    assert_equal @plan_task, assigns(:plan_task)
  end

  test "should get edit" do
    get :edit, :id => @plan_task.id

    assert_response :success
    assert_template 'edit'
    assert_equal @plan_task, assigns(:plan_task)
  end

  test "should deny edit" do
    @request.session[:user_id] = 3

    get :edit, :id => @plan_task.id

    assert_response 403
  end

  test "should get edit create_perm" do
    set_create_only
    get :edit, :id => 2

    assert_response :success
  end

  test "should get edit own" do
    set_no_permissions
    get :edit, :id => 2

    assert_response :success
  end

  test "should update plan_task" do
    test_update_ok
  end

  test "should not update invalid" do
    PlanTask.any_instance.stubs(:update_attributes).returns(false)
    put_update
    assert_template 'edit'
  end

  test "should deny update" do
    @request.session[:user_id] = 3

    put_update

    assert_response 403
  end

  test "should update create_perm" do
    set_create_only
    test_update_ok
  end

  test "should update own" do
    set_no_permissions
    test_update_ok
  end

  test "should destroy plan_task" do
    assert_difference('PlanTask.count', -1) do
      delete :destroy, :id => 4
    end

    assert_redirected_to project_plan_tasks_path(@plan_task.project)
  end

private
  def set_no_permissions
    Role.find(1).remove_permission! :planner_admin
  end

  def set_create_only
    set_no_permissions
    Role.find(1).add_permission! :planner_task_create
  end

  def post_create
    post :create, :project_id => 1, :plan_task => {
      :owner_id => @plan_task.owner_id,
      :name => 'New name',
      :description => 'New descr',
      :wbs => 'New WBS',
      :parent_task => @plan_task.parent_task
    }
  end

  def test_create_ok
    assert_difference('PlanTask.count') do
      post_create
    end

    assert_redirected_to project_plan_tasks_url(assigns(:project))

    tmp = assigns(:plan_task)
    assert_equal 'New name', tmp.name
    assert_equal 'New descr', tmp.description
    assert_equal 'New WBS', tmp.wbs
  end

  def put_update
    put :update, :id => @plan_task.id, :plan_task => {
      :owner_id => @plan_task.owner_id,
      :name => 'New name',
      :description => 'New descr',
      :wbs => 'New WBS',
      :parent_task => @plan_task.parent_task
    }
  end

  def test_update_ok
    put_update

    assert_redirected_to project_plan_tasks_url(assigns(:project))

    tmp = PlanTask.find(@plan_task.id)
    assert_equal 'New name', tmp.name
    assert_equal 'New descr', tmp.description
    assert_equal 'New WBS', tmp.wbs
  end
end
