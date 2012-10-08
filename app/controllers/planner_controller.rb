class PlannerController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @teams = PlanGroup.all_project_groups(@project).teams.includes(:users)
    @groups = PlanGroup.all_project_groups(@project).groups.includes(:users)
  end
end
