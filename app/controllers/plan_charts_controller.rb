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
    start_date = params[:week_start_date]
    start_date = start_date ? Date.parse(start_date) : nil
    num_weeks = params[:num_weeks]
    num_weeks = num_weeks ? num_weeks.to_i : nil

    @include_ready  = params[:include_ready]  != "0"
    @include_new    = params[:include_new]    == "1"
    @include_denied = params[:include_denied] == "1"

    @states = [ PlanRequest::STATUS_APPROVED ]
    @states << PlanRequest::STATUS_READY  if @include_ready
    @states << PlanRequest::STATUS_NEW    if @include_new
    @states << PlanRequest::STATUS_DENIED if @include_denied

    @chart = PlanChart.new(@project, start_date, num_weeks)
  end
end
