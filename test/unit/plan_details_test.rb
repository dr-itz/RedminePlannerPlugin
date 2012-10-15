require File.dirname(__FILE__) + '/../test_helper'

class PlanDetailsTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_groups, :plan_group_members, :plan_tasks,
    :plan_requests, :plan_details

  setup do
    User.current = User.find(2)
  end

  test "create new" do
    tmp = PlanDetail.new(:percentage => 80)
    tmp.request_id = 2
    tmp.week = 201240
    assert tmp.save
  end

  test "create new fail mass_assign" do
    tmp = PlanDetail.new(:request_id => 2, :week => 201240, :percentage => 80)
    assert_equal 0, tmp.request_id
    assert !tmp.week
  end

  test "validations" do
    # duplicate
    tmp = PlanDetail.new(:percentage => 80)
    tmp.request_id = 2
    tmp.week = 201239
    assert !tmp.valid?

    # ok, other request
    tmp = PlanDetail.new(:percentage => 80, :ok_mon => false)
    tmp.request_id = 3
    tmp.week = 201239
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
    tmp.week = 201239
    assert_equal Date.parse("2012-09-24"), tmp.week_start_date
  end

  test "week_start_date assign" do
    tmp = PlanDetail.new
    tmp.week_start_date = "2012-09-24"
    assert_equal 201239, tmp.week

    tmp.week_start_date = "2012-09-27"
    assert_equal 201239, tmp.week
  end

  test "week_start_date cwyear" do
    tmp = PlanDetail.new
    tmp.week_start_date = "2012-12-31"
    assert_equal 201301, tmp.week
  end

  test "bulk_update" do
    list = PlanDetail.bulk_update(
      PlanRequest.find(2), { :week_start_date => "2012-09-24", :percentage => 70, :ok_mon => false, :ok_tue => false }, 3)

    assert_equal 3, list.length
    assert list[0].id != 0
    assert_equal 201239, list[0].week
    assert_equal 70, list[0].percentage
    assert !list[0].ok_mon
    assert !list[0].ok_tue

    assert list[1].id != 0
    assert_equal 201240, list[1].week
    assert_equal 70, list[1].percentage
    assert !list[1].ok_mon
    assert !list[1].ok_tue

    assert list[2].id != 0
    assert_equal 201241, list[2].week
    assert_equal 70, list[2].percentage
    assert !list[2].ok_mon
    assert !list[2].ok_tue
  end

  test "bulk_update cwyear" do
    list = PlanDetail.bulk_update(
      PlanRequest.find(2), { :week_start_date => "2012-12-31", :percentage => 70, :ok_mon => false, :ok_tue => false }, 1)

    assert_equal 1, list.length
    assert list[0].id != 0
    assert_equal 201301, list[0].week
    assert_equal 70, list[0].percentage
    assert !list[0].ok_mon
    assert !list[0].ok_tue
  end

  test "bulk_update year week" do
    list = PlanDetail.bulk_update(
      PlanRequest.find(2), { :year => "2012", :week => "39", :percentage => 70, :ok_mon => false, :ok_tue => false }, 3)

    assert_equal 3, list.length
    assert list[0].id != 0
    assert_equal 201239, list[0].week
    assert_equal 70, list[0].percentage
    assert !list[0].ok_mon
    assert !list[0].ok_tue

    assert list[1].id != 0
    assert_equal 201240, list[1].week
    assert_equal 70, list[1].percentage
    assert !list[1].ok_mon
    assert !list[1].ok_tue

    assert list[2].id != 0
    assert_equal 201241, list[2].week
    assert_equal 70, list[2].percentage
    assert !list[2].ok_mon
    assert !list[2].ok_tue
  end

  test "scope user_details range 1" do
    list = PlanDetail.user_details(3, 201239, 201242)

    assert_equal 3, list.length
    assert_equal 1, list[0].id
    assert_equal 4, list[1].id
    assert_equal 5, list[2].id
  end

  test "scope user_details range 2" do
    list = PlanDetail.user_details(3, 201240, 201242)

    assert_equal 2, list.length
    assert_equal 4, list[0].id
    assert_equal 5, list[1].id
  end

  test "scope user_details range 3" do
    list = PlanDetail.user_details(3, 201239, 201241)

    assert_equal 2, list.length
    assert_equal 1, list[0].id
    assert_equal 4, list[1].id
  end

  test "scope group overview" do
    list = PlanDetail.group_overview(1, 201238, 201242)

    assert_equal 5, list.length

    detail = list[0]
    assert_equal 201238, detail.week
    assert_equal 2, detail.resource_id
    assert_equal 60, detail.percentage

    detail = list[1]
    assert_equal 201238, detail.week
    assert_equal 3, detail.resource_id
    assert_equal 60, detail.percentage

    detail = list[2]
    assert_equal 201239, detail.week
    assert_equal 3, detail.resource_id
    assert_equal 80, detail.percentage

    detail = list[3]
    assert_equal 201241, detail.week
    assert_equal 3, detail.resource_id
    assert_equal 70, detail.percentage

    detail = list[4]
    assert_equal 201242, detail.week
    assert_equal 3, detail.resource_id
    assert_equal 50, detail.percentage
  end
end
