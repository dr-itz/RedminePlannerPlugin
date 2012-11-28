class PlanChartsController < ApplicationController
  unloadable
  menu_item :planner
  helper :planner

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    set_range
    @user = User.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_user_chart(@project, @user, @start_date, @num_weeks)
    update_range
  end

  def show_group
    set_range
    @group = PlanGroup.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_group_chart(@project, @group, @start_date, @num_weeks)
    update_range
  end

  def show_task
    set_range
    @task = PlanTask.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_task_chart(@project, @task, @start_date, @num_weeks)
    update_range
  end

private

  def set_range
    start_date = params[:week_start_date]
    if start_date
      @start_date = Date.parse(start_date)
    else
      @start_date = nil
    end
    num_weeks = params[:num_weeks]
    @num_weeks = num_weeks ? num_weeks.to_i : nil
  end

  def update_range
    @start_date = @chart.start_date
    @num_weeks = @chart.weeks
  end
end
