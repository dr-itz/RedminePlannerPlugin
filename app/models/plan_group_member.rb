class PlanGroupMember < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :plan_group

  validates_uniqueness_of :user, :scope => [:plan_group_id]
end
