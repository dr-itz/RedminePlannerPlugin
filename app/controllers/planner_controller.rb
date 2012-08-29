class PlannerController < ApplicationController
  unloadable

  before_filter :find_project, :only => [:index]

  def index
  end
end
