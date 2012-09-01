class PlanGroup < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :team_leader, :class_name => 'User', :foreign_key => 'leader_id'
end
