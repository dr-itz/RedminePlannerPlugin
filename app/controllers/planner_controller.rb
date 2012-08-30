class PlannerController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize, :only => [:index]

  def index
  end
end
