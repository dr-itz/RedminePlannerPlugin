require File.dirname(__FILE__) + '/../test_helper'

class PlanCalcTest < ActiveSupport::TestCase
  fixtures :projects, :users, :plan_tasks, :plan_group_members, :plan_requests, :plan_details

  test "normalize_date" do
    assert_equal Date.parse('2012-9-17'), PlanCalc.normalize_date(Date.parse('2012-9-19')) 
  end

  test "weekly_load" do
    calc = PlanCalc.new(Project.find(1))
    calc.prepare_user_req_workload(PlanRequest.find(2),
      [ PlanRequest::STATUS_APPROVED, PlanRequest::STATUS_READY, PlanRequest::STATUS_NEW ])

    assert_equal  60, calc.weekly_load(201238)
    assert_equal  80, calc.weekly_load(201239)
    assert_equal 130, calc.weekly_load(201241)
  end

  test "workload_class and workload_color" do
    calc = PlanCalc.new(Project.find(1))

    assert_equal 100, calc.work_target
    assert_equal  80, calc.work_ths_ok
    assert_equal 110, calc.work_ths_over

    assert_equal PlanCalc::WORKLOAD_CLASS_FREE, calc.workload_class( 60)
    assert_equal PlanCalc::WORKLOAD_CLASS_OK,   calc.workload_class( 90)
    assert_equal PlanCalc::WORKLOAD_CLASS_OVER, calc.workload_class(120)
    assert_equal "background-color: gold;color: black;",    calc.workload_color( 60)
    assert_equal "background-color: #2ca02c;color: white;", calc.workload_color( 90)
    assert_equal "background-color: #d62728;color: white;", calc.workload_color(120)
  end

  test "scale" do
    calc = PlanCalc.new(Project.find(1))
    calc.scale = 2

    assert_equal 200, calc.work_target
    assert_equal 160, calc.work_ths_ok
    assert_equal 220, calc.work_ths_over
  end
end
