class PlanGroupMember < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :plan_group

  validates_uniqueness_of :user_id, :scope => [:plan_group_id]

  def <=>(member)
    user <=> member.user
  end
end
