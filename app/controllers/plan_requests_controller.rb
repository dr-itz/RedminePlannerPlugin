class PlanRequestsController < ApplicationController
  unloadable

  include PlanRequestStateHandling

  menu_item :planner
  helper :planner

  before_filter :find_project_by_project_id, :only => [:index, :new, :create]
  before_filter :find_plan_request, :only => [:show, :edit, :update, :destroy, :send_request, :approve]
  before_filter :authorize, :except => [:edit, :update, :desroy]
  before_filter :authorize_create, :only => [:new, :create]
  before_filter :authorize_edit, :only => [:edit, :update, :destroy]

  def index
    @requests_requester = PlanRequest.all_open_requests_requester(@project)
    @requests_approver  = PlanRequest.all_open_requests_approver(@project)
    @requests_requestee = PlanRequest.all_open_requests_requestee(@project)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @plan_requests }
    end
  end

  def show
    process_request_states
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @plan_request }
    end
  end

  def new
    @plan_request = PlanRequest.new
    @tasks = PlanTask.all_project_tasks(@project).assignable

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @plan_request }
    end
  end

  def edit
    @tasks = PlanTask.all_project_tasks(@project).assignable
  end

  def create
    @plan_request = PlanRequest.new(params[:plan_request])
    @plan_request.requester = User.current

    respond_to do |format|
      if @plan_request.save
        format.html { redirect_to plan_request_url(@plan_request), :notice => l(:notice_successful_create) }
        format.json { render :json => @plan_request, :status => :created, :location => @plan_request }
      else
        format.html {
          @tasks = PlanTask.all_project_tasks(@project).assignable
          render :action => "new"
        }
        format.json { render :json => @plan_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @plan_request.update_attributes(params[:plan_request])
        format.html { redirect_to plan_request_url(@plan_request), :notice => l(:notice_successful_update)}
        format.json { head :no_content }
      else
        format.html {
          @tasks = PlanTask.all_project_tasks(@project).assignable
          render :action => "edit"
        }
        format.json { render :json => @plan_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan_request.destroy

    respond_to do |format|
      format.html { redirect_to project_plan_requests_url(@project) }
      format.json { head :no_content }
    end
  end

  def send_request
    return render_403 unless @plan_request.can_request?

    if @plan_request.send_request
      respond_to do |format|
        format.html { redirect_to plan_request_url(@plan_request) }
        format.json { head :no_content }
      end
    else
      process_request_states
      respond_to do |format|
        format.html { render :action => "show" }
        format.json { render :json => @plan_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def approve
    return render_403 unless @plan_request.can_approve?
    return render_404 unless params[:plan_request]

    attrs = params[:plan_request]
    @plan_request.approve_deny_request(attrs[:status], attrs[:approver_notes])

    respond_to do |format|
      format.html { redirect_to plan_request_url(@plan_request) }
      format.json { head :no_content }
    end
  end

  def can_create_request?
    current = User.current
    current.allowed_to?(:planner_requests, @project) ||
      current.allowed_to?(:planner_admin, @project)
  end
private
  def find_plan_request
    @plan_request = PlanRequest.includes(
      {:task => :project}, :requester, :resource, :approver).find(params[:id])
    return render_403 unless @plan_request.present?
    @project = @plan_request.task.project
  end

  def authorize_create
    return render_403 unless can_create_request?
  end

  def authorize_edit
    return render_403 unless @plan_request.can_edit?
  end
end
