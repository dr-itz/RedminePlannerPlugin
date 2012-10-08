class PlanChartsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    set_range

    @user = User.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_user_chart(@user, @start_date, @num_weeks)
    @start_date = @chart.start_date
  end

  def show_group
    set_range

    @group = PlanGroup.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_group_chart(@group, @start_date, @num_weeks)
    @start_date = @chart.start_date
  end
private

  def set_range
    start_date = params[:week_start_date]
    if start_date
      @start_date = Date.parse(start_date)
    else
      @start_date = Date.today - 7
    end
    num_weeks = params[:num_weeks]
    @num_weeks = (num_weeks || 8).to_i
  end
end
