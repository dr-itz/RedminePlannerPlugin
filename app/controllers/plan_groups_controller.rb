class PlanGroupsController < ApplicationController
  unloadable
  menu_item :planner

  before_filter :find_project_by_project_id, :only => [:index, :new, :create]
  before_filter :find_plan_group, :only => [:show, :edit, :update, :destroy, :remove_membership]
  before_filter :authorize

  def index
    @plan_groups = PlanGroup.all_project_groups(@project)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @plan_groups }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @plan_group }
    end
  end

  def new
    @plan_group = PlanGroup.new
    @plan_group.project = @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @plan_group }
    end
  end

  def edit

  end

  def create
    @plan_group = PlanGroup.new(params[:plan_group])
    @plan_group.project = @project

    respond_to do |format|
      if @plan_group.save
        format.html { redirect_to @plan_group, :notice => l(:notice_successful_create) }
        format.json { render :json => @plan_group, :status => :created, :location => @plan_group }
      else
        format.html { render :action => "new" }
        format.json { render :json => @plan_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @plan_group.update_attributes(params[:plan_group])
        format.html { redirect_to @plan_group, :notice => l(:notice_successful_update)}
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @plan_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan_group.destroy

    respond_to do |format|
      format.html { redirect_to project_plan_groups_url(@project) }
      format.json { head :no_content }
    end
  end

  def remove_membership
    member = PlanGroupMember.find(params[:membership_id])
    member.destroy

    respond_to do |format|
      format.html { redirect_to plan_groups_url(@plan_group) }
      format.js
    end
  end

  def can_edit_group?
    User.current.allowed_to?(:planner_admin, @project)
  end
private
  def find_plan_group
    @plan_group = PlanGroup.find(params[:id], :include => [:project])
    @project = @plan_group.project
  end
end
