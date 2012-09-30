# == Schema Information
#
# Table name: plan_details
#
#  id         :integer          not null, primary key
#  request_id :integer          default(0), not null
#  year       :integer          not null
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

  validates_uniqueness_of :week, :scope => [:request_id, :year]

  attr_protected :request_id, :year, :week, :week_start_date

  default_scope order(:year, :week)


  def self.bulk_update(request, detail_params, num)
    detail_list = []

    start_date = detail_params[:week_start_date]
    if start_date
      date = Date.parse(start_date)
    else
      date = Date.commercial(detail_params[:year], detail_params[:week], 1)
    end

    for i in 1..num
      detail = self.where(:request_id => request.id, :year => date.cwyear, :week => date.cweek).first_or_initialize
      detail.update_attributes(detail_params)
      detail_list << detail
      date = date + 7
    end
    detail_list
  end

  def week_start_date
    return nil if year == nil
    Date.commercial(year, week, 1)
  end

  def week_start_date=(str)
    date = Date.parse(str)
    self.year = date.cwyear
    self.week = date.cweek
  end

  def can_edit?
    request.can_edit?
  end
end
