class PlanTasksController < ApplicationController
  unloadable
  menu_item :planner

  before_filter :find_project_by_project_id, :only => [:index, :new, :create]
  before_filter :find_plan_task, :only => [:show, :edit, :update, :destroy]
  before_filter :authorize, :except => [:edit, :update]

  def index
    @plan_tasks = PlanTask.all_project_tasks(@project)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @plan_tasks }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @plan_task }
    end
  end

  def new
    return render_403 unless can_create_task?

    @plan_task = PlanTask.new
    @plan_task.project = @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @plan_task }
    end
  end

  def edit
    render_403 unless @plan_task.can_edit?
  end

  def create
    return render_403 unless can_create_task?

    @plan_task = PlanTask.new(params[:plan_task])
    @plan_task.project = @project

    respond_to do |format|
      if @plan_task.save
        format.html { redirect_to project_plan_tasks_url(@project), :notice => l(:notice_successful_create) }
        format.json { render :json => @plan_task, :status => :created, :location => @plan_task }
      else
        format.html { render :action => "new" }
        format.json { render :json => @plan_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    return render_403 unless @plan_task.can_edit?

    respond_to do |format|
      if @plan_task.update_attributes(params[:plan_task])
        format.html { redirect_to project_plan_tasks_url(@project), :notice => l(:notice_successful_update)}
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @plan_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan_task.destroy

    respond_to do |format|
      format.html { redirect_to project_plan_tasks_url(@project) }
      format.json { head :no_content }
    end
  end

  def can_create_task?
    current = User.current
    current.allowed_to?(:planner_task_create, @project) ||
      current.allowed_to?(:planner_admin, @project)
  end
private
  def find_plan_task
    @plan_task = PlanTask.find(params[:id], :include => [:project])
    @project = @plan_task.project
  end
end
