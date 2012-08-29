class PlannerController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => [:index]

  def index
  end
end
