class PlanGroupMember < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :plan_group
end
