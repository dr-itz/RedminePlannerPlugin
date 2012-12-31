class PlanChartsController < ApplicationController
  unloadable
  menu_item :planner
  helper :planner

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    setup
    @user = User.find(params[:id])
    @chart.generate_user_chart(@user, @states)
  end

  def show_group
    setup
    @group = PlanGroup.find(params[:id])
    @chart.generate_group_chart(@group, @states)
  end

  def show_task
    setup
    @task = PlanTask.find(params[:id])
    @chart.generate_task_chart(@task, @states)
  end

private

  def setup
    start_date = params[:start]
    start_date = start_date ? Date.parse(start_date) : nil
    num_weeks = params[:weeks]
    num_weeks = num_weeks ? num_weeks.to_i : nil

    @inc_ready  = params[:inc_ready]  != "0"
    @inc_new    = params[:inc_new]    == "1"
    @inc_denied = params[:inc_denied] == "1"

    @states = [ PlanRequest::STATUS_APPROVED ]
    @states << PlanRequest::STATUS_READY  if @inc_ready
    @states << PlanRequest::STATUS_NEW    if @inc_new
    @states << PlanRequest::STATUS_DENIED if @inc_denied

    @chart = PlanChart.new(@project, start_date, num_weeks)
  end
end
