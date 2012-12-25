class PlannerConfigController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def update
    config = PlanConfig.project_config(@project)
    config.update_config params[:config]

    flash[:notice] = l(:notice_successful_update)
    redirect_to :controller => 'projects',
      :action => "settings", :id => @project, :tab => 'planner'
  end
end
