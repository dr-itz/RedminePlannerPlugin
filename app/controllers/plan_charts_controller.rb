class PlanChartsController < ApplicationController
  unloadable
  menu_item :planner
  helper :planner

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    set_criteria
    @user = User.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_user_chart(@project, @user, @states, @start_date, @num_weeks)
    update_range
  end

  def show_group
    set_criteria
    @group = PlanGroup.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_group_chart(@project, @group, @states, @start_date, @num_weeks)
    update_range
  end

  def show_task
    set_criteria
    @task = PlanTask.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_task_chart(@project, @task, @states, @start_date, @num_weeks)
    update_range
  end

private

  def set_criteria
    start_date = params[:week_start_date]
    if start_date
      @start_date = Date.parse(start_date)
    else
      @start_date = nil
    end
    num_weeks = params[:num_weeks]
    @num_weeks = num_weeks ? num_weeks.to_i : nil

    @inc_ready  = params[:include_ready]  != "0"
    @inc_new    = params[:include_new]    == "1"
    @inc_denied = params[:include_denied] == "1"

    @states = [ PlanRequest::STATUS_APPROVED ]
    @states << PlanRequest::STATUS_READY  if @inc_ready
    @states << PlanRequest::STATUS_NEW    if @inc_new
    @states << PlanRequest::STATUS_DENIED if @inc_denied
  end

  def update_range
    @start_date = @chart.start_date
    @num_weeks = @chart.weeks
  end
end
