# == Schema Information
#
# Table name: plan_group_members
#
#  id            :integer          not null, primary key
#  plan_group_id :integer          default(0), not null
#  user_id       :integer          default(0), not null
#

class PlanGroupMember < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :plan_group

  validates_uniqueness_of :user_id, :scope => [:plan_group_id]

  def <=>(member)
    user <=> member.user
  end
end
