# == Schema Information
#
# Table name: plan_group_members
#
#  id            :integer          not null, primary key
#  plan_group_id :integer          default(0), not null
#  user_id       :integer          default(0), not null
#

require File.dirname(__FILE__) + '/../test_helper'

class PlanGroupMemberTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :users, :plan_groups, :plan_group_members

  test "validations" do
    # duplicate record
    tmp = PlanGroupMember.new(:plan_group_id => 1, :user_id => 2)
    assert !tmp.valid?
  end
end
