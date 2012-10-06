class PlannerController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    @user = User.find(params[:id])
    @chart = PlanChart.new
    @chart.generate_user_chart(@user, Date.today, 8)
  end
end
