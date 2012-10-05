class PlannerController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
  end

  def show_user
    @user = User.find(params[:id])

  end
end
