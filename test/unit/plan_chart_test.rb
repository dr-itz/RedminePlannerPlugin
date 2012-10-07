require File.dirname(__FILE__) + '/../test_helper'

class PlanChartTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_tasks, :plan_requests, :plan_details

  setup do
  end

  test "generate user chart" do
    chart = PlanChart.new
    chart.generate_user_chart(User.find(3), Date.parse('2012-9-18'), 6)

    assert_equal Date.parse('2012-9-17'), chart.start_date
    assert_equal Date.parse('2012-10-22'), chart.end_date

    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal '[60, 80, 0, 0, 0, 0]', chart.data[0].inspect
    assert_equal '[0, 0, 0, 70, 50, 0]', chart.data[1].inspect
    assert_equal '["2012-38", "2012-39", "2012-40", "2012-41", "2012-42", "2012-43"]', chart.ticks.inspect
    assert_equal '[{:label=>"Req. #2: Task 2"}, {:label=>"Req. #3: Task 2"}]', chart.series.inspect
  end

  test "generate user chart without data" do
    chart = PlanChart.new
    chart.generate_user_chart(User.find(3), Date.parse('2012-11-15'), 6)

    assert_equal Date.parse('2012-11-12'), chart.start_date
    assert_equal Date.parse('2012-12-17'), chart.end_date

    assert_equal 1, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 0, chart.series.length

    assert_equal '[0, 0, 0, 0, 0, 0]', chart.data[0].inspect
    assert_equal '["2012-46", "2012-47", "2012-48", "2012-49", "2012-50", "2012-51"]', chart.ticks.inspect
  end
end
