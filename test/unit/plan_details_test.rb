require File.dirname(__FILE__) + '/../test_helper'

class PlanDetailsTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_tasks, :plan_requests, :plan_details

  setup do
    User.current = User.find(2)
  end

  test "create new" do
    tmp = PlanDetail.new(:percentage => 80)
    tmp.request_id = 2
    tmp.year = 2012
    tmp.week = 40
    assert tmp.save
  end

  test "create new fail mass_assign" do
    tmp = PlanDetail.new(:request_id => 2, :year => 2012, :week => 40, :percentage => 80)
    assert_equal 0, tmp.request_id
    assert !tmp.year
    assert !tmp.week
  end

  test "validations" do
    # duplicate
    tmp = PlanDetail.new(:percentage => 80)
    tmp.request_id = 2
    tmp.year = 2012
    tmp.week = 39
    assert !tmp.valid?

    # ok, other request
    tmp = PlanDetail.new(:percentage => 80, :ok_mon => false)
    tmp.request_id = 3
    tmp.year = 2012
    tmp.week = 39
    assert tmp.valid?
    assert tmp.save
  end

  test "test default_scope" do
    all = PlanDetail.where(:request_id => 2)
    assert_equal 2, all.length
    assert_equal all[0], PlanDetail.find(2)
    assert_equal all[1], PlanDetail.find(1)
  end

  test "test can_edit" do
    # plan_detail 2 has plan_request 2
    req = PlanDetail.find(2)
    assert req.can_edit?

    # plan_detail 3 has plan_request 1
    req = PlanDetail.find(3)
    assert !req.can_edit?
  end

  test "week_start_date" do
    tmp = PlanDetail.new
    assert !tmp.week_start_date
    tmp.year = 2012
    assert !tmp.week_start_date
    tmp.week = 39
    assert_equal Date.parse("2012-09-24"), tmp.week_start_date
  end

  test "week_start_date assign" do
    tmp = PlanDetail.new
    tmp.week_start_date = "2012-09-24"
    assert_equal 2012, tmp.year
    assert_equal 39, tmp.week

    tmp.week_start_date = "2012-09-27"
    assert_equal 2012, tmp.year
    assert_equal 39, tmp.week
  end

  test "week_start_date cwyear" do
    tmp = PlanDetail.new
    tmp.week_start_date = "2012-12-31"
    assert_equal 2013, tmp.year
    assert_equal 1, tmp.week
  end

  test "bulk_update" do
    list = PlanDetail.bulk_update(
      PlanRequest.find(2), { :week_start_date => "2012-09-24", :percentage => 70, :ok_mon => false, :ok_tue => false }, 3)

    assert_equal 3, list.length
    assert list[0].id != 0
    assert_equal 2012, list[0].year
    assert_equal 39, list[0].week
    assert_equal 70, list[0].percentage
    assert !list[0].ok_mon
    assert !list[0].ok_tue

    assert list[1].id != 0
    assert_equal 2012, list[1].year
    assert_equal 40, list[1].week
    assert_equal 70, list[1].percentage
    assert !list[1].ok_mon
    assert !list[1].ok_tue

    assert list[2].id != 0
    assert_equal 2012, list[2].year
    assert_equal 41, list[2].week
    assert_equal 70, list[2].percentage
    assert !list[2].ok_mon
    assert !list[2].ok_tue
  end

  test "bulk_update cwyear" do
    list = PlanDetail.bulk_update(
      PlanRequest.find(2), { :week_start_date => "2012-12-31", :percentage => 70, :ok_mon => false, :ok_tue => false }, 1)

    assert_equal 1, list.length
    assert list[0].id != 0
    assert_equal 2013, list[0].year
    assert_equal 1, list[0].week
    assert_equal 70, list[0].percentage
    assert !list[0].ok_mon
    assert !list[0].ok_tue
  end
end
