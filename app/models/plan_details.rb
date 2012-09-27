# == Schema Information
#
# Table name: plan_details
#
#  id         :integer          not null, primary key
#  request_id :integer          default(0), not null
#  year       :integer          not null
#  week       :integer          not null
#  percentage :integer          default(0), not null
#  ok_mon     :boolean          default(TRUE), not null
#  ok_tue     :boolean          default(TRUE), not null
#  ok_wed     :boolean          default(TRUE), not null
#  ok_thu     :boolean          default(TRUE), not null
#  ok_fri     :boolean          default(TRUE), not null
#  ok_sat     :boolean          default(FALSE), not null
#  ok_sun     :boolean          default(FALSE), not null
#

class PlanDetails < ActiveRecord::Base
  unloadable

  include Redmine::I18n

  belongs_to :request, :class_name => 'PlanRequest', :foreign_key => 'request_id'

  default_scope order(:year, :week)

  validates_uniqueness_of :week, :scope => [:request_id, :year]

  def can_edit?
    request.can_edit?
  end
end
