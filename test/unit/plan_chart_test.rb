require File.dirname(__FILE__) + '/../test_helper'

class PlanChartTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_tasks, :plan_groups, :plan_group_members, :plan_requests, :plan_details

  setup do
  end

  test "generate user chart" do
    chart = PlanChart.new
    chart.generate_user_chart(Project.find(1), User.find(3), Date.parse('2012-9-18'), 6)

    assert_equal Date.parse('2012-9-17'), chart.start_date
    assert_equal Date.parse('2012-10-22'), chart.end_date

    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal [60, 80, 0, 60, 0, 0], chart.data[0]
    assert_equal [0, 0, 0, 70, 50, 0], chart.data[1]
    assert_equal ["W38", "W39", "W40", "W41", "W42", "W43"], chart.week_ticks
    assert_equal [{:color => "#3182bd"}, {:color => "#6baed6"}], chart.series

    assert_equal 100, chart.limit
    assert_equal 80, chart.ths_ok
    assert_equal 110, chart.ths_over
    assert_equal 3, chart.threshold_data.length
    assert_equal [
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 1, 130], [5, 0, 0], [6, 0, 0]],
      [[1, 0, 0], [2, 1, 80], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 1, 60], [2, 0, 0], [3, 1, 0], [4, 0, 0], [5, 1, 50], [6, 1, 0]]
    ], chart.threshold_data
  end

  test "generate user chart without data" do
    chart = PlanChart.new
    chart.generate_user_chart(Project.find(1), User.find(3), Date.parse('2012-11-15'), 6)

    assert_equal Date.parse('2012-11-12'), chart.start_date
    assert_equal Date.parse('2012-12-17'), chart.end_date

    assert_equal 1, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 0, chart.series.length

    assert_equal [0, 0, 0, 0, 0, 0], chart.data[0]
    assert_equal ["W46", "W47", "W48", "W49", "W50", "W51"], chart.week_ticks

    assert_equal 100, chart.limit
    assert_equal 80, chart.ths_ok
    assert_equal 110, chart.ths_over
    assert_equal 3, chart.threshold_data.length
    assert_equal [
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 1, 0], [2, 1, 0], [3, 1, 0], [4, 1, 0], [5, 1, 0], [6, 1, 0]]
    ], chart.threshold_data
  end

  test "generate group chart" do
    chart = PlanChart.new
    chart.generate_group_chart(Project.find(1), PlanGroup.find(1), Date.parse('2012-9-18'), 6)

    assert_equal Date.parse('2012-9-17'), chart.start_date
    assert_equal Date.parse('2012-10-22'), chart.end_date

    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal [60, 80, 0, 130, 50, 0], chart.data[0]
    assert_equal [60, 0, 0, 0, 0, 0], chart.data[1]
    assert_equal ["W38", "W39", "W40", "W41", "W42", "W43"], chart.week_ticks
    assert_equal [{:color => "#3182bd"}, {:color => "#6baed6"}], chart.series

    assert_equal 2, chart.series_details.length
    assert_equal "Dave Lopper", chart.series_details[0].name
    assert_equal "John Smith", chart.series_details[1].name

    assert_equal 200, chart.limit
    assert_equal 160, chart.ths_ok
    assert_equal 220, chart.ths_over
    assert_equal 3, chart.threshold_data.length
    assert_equal [
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 1, 120], [2, 1, 80], [3, 1, 0], [4, 1, 130], [5, 1, 50], [6, 1, 0]]
    ], chart.threshold_data
  end

  test "generate group chart without data" do
    chart = PlanChart.new
    chart.generate_group_chart(Project.find(1), PlanGroup.find(1), Date.parse('2012-11-15'), 6)

    assert_equal Date.parse('2012-11-12'), chart.start_date
    assert_equal Date.parse('2012-12-17'), chart.end_date

    assert_equal 2, chart.data.length
    assert_equal 6, chart.data[0].length
    assert_equal 6, chart.ticks.length
    assert_equal 2, chart.series.length

    assert_equal [0, 0, 0, 0, 0, 0], chart.data[0]
    assert_equal [0, 0, 0, 0, 0, 0], chart.data[1]
    assert_equal [{:color => "#3182bd"}, {:color => "#6baed6"}], chart.series
    assert_equal ["W46", "W47", "W48", "W49", "W50", "W51"], chart.week_ticks

    assert_equal 2, chart.series_details.length
    assert_equal "Dave Lopper", chart.series_details[0].name
    assert_equal "John Smith", chart.series_details[1].name

    assert_equal 200, chart.limit
    assert_equal 160, chart.ths_ok
    assert_equal 220, chart.ths_over
    assert_equal 3, chart.threshold_data.length
    assert_equal [
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 0, 0], [2, 0, 0], [3, 0, 0], [4, 0, 0], [5, 0, 0], [6, 0, 0]],
      [[1, 1, 0], [2, 1, 0], [3, 1, 0], [4, 1, 0], [5, 1, 0], [6, 1, 0]]
    ], chart.threshold_data
  end

  test "limit 52 weeks user chart" do
    chart = PlanChart.new
    chart.generate_user_chart(Project.find(1), User.find(3), Date.parse('2012-11-15'), 77)

    assert_equal 52, chart.weeks
    assert_equal 52, chart.data[0].length
  end

  test "limit 52 weeks group chart" do
    chart = PlanChart.new
    chart.generate_group_chart(Project.find(1), PlanGroup.find(1), Date.parse('2012-11-15'), 78)

    assert_equal 52, chart.weeks
    assert_equal 52, chart.data[0].length
  end
end
