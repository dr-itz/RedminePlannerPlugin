# == Schema Information
#
# Table name: plan_details
#
#  id         :integer          not null, primary key
#  request_id :integer          default(0), not null
#  week       :integer          not null
#  percentage :integer          default(80), not null
#  ok_mon     :boolean          default(TRUE), not null
#  ok_tue     :boolean          default(TRUE), not null
#  ok_wed     :boolean          default(TRUE), not null
#  ok_thu     :boolean          default(TRUE), not null
#  ok_fri     :boolean          default(TRUE), not null
#  ok_sat     :boolean          default(FALSE), not null
#  ok_sun     :boolean          default(FALSE), not null
#

class PlanDetail < ActiveRecord::Base
  unloadable

  include Redmine::I18n

  belongs_to :request, :class_name => 'PlanRequest', :foreign_key => 'request_id'

  validates_uniqueness_of :week, :scope => [:request_id]

  attr_protected :request_id, :week, :week_start_date

  default_scope order(:week)

  scope :user_details, lambda { |user, startweek, endweek|
    joins(:request).where(
      "plan_requests.resource_id = :user_id AND week >= :startweek AND week <= :endweek",
      :user_id => user.is_a?(User) ? user.id : user, :startweek => startweek, :endweek => endweek)
  }

  scope :group_overview, lambda { |group, startweek, endweek|
    select("sum(percentage) AS percentage, resource_id, week").joins(:request).group("resource_id, week").where(
      "plan_requests.resource_id IN (" +
        "SELECT user_id FROM plan_group_members WHERE plan_group_id = :group_id) " +
      " AND week >= :startweek AND week <= :endweek",
      :group_id => group.is_a?(PlanGroup) ? group.id : group, :startweek => startweek, :endweek => endweek)
  }

  def self.bulk_update(request, detail_params, num)
    detail_list = []

    start_date = detail_params[:week_start_date]
    if start_date
      date = Date.parse(start_date)
    else
      date = Date.commercial(detail_params[:year], detail_params[:week], 1)
    end

    num.times do
      detail = self.where(:request_id => request.id, :week => date.cwyear * 100 + date.cweek).first_or_initialize
      detail.update_attributes(detail_params)
      detail_list << detail
      date += 7
    end
    detail_list
  end

  def cwyear
    week / 100
  end

  def cweek
    week % 100
  end

  def week_start_date
    return nil if week == nil
    Date.commercial(self.cwyear, self.cweek, 1)
  end

  def week_start_date=(str)
    date = Date.parse(str)
    self.week = date.cwyear * 100 + date.cweek
  end

  def can_edit?
    request.can_edit?
  end
end
