class PlannerController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    start_date = params[:week_start_date]
    if start_date
      @start_date = Date.parse(start_date)
    else
      @start_date = Date.today
    end
    num_weeks = params[:num_weeks]
    @num_weeks = (num_weeks || 8).to_i

    @user = User.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_user_chart(@user, @start_date, @num_weeks)
  end
end
