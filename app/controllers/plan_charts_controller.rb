class PlanChartsController < ApplicationController
  unloadable

  include PlanRequestStateHandling

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

    process_request_states

    @chart = PlanChart.new(@project, start_date, num_weeks)
  end
end
