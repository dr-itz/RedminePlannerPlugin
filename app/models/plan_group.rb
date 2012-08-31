class PlanGroup < ActiveRecord::Base
  unloadable

  belongs_to :project
end
