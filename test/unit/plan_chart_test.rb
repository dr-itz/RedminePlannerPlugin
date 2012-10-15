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

    assert_equal [60, 80, 0, 0, 0, 0], chart.data[0]
    assert_equal [0, 0, 0, 70, 50, 0], chart.data[1]
    assert_equal ["2012-38", "2012-39", "2012-40", "2012-41", "2012-42", "2012-43"], chart.ticks
    assert_equal [{:color => "#3182bd"}, {:color => "#6baed6"}], chart.series
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
    assert_equal ["2012-46", "2012-47", "2012-48", "2012-49", "2012-50", "2012-51"], chart.ticks
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

    assert_equal [60, 80, 0, 70, 50, 0], chart.data[0]
    assert_equal [60, 0, 0, 0, 0, 0], chart.data[1]
    assert_equal ["2012-38", "2012-39", "2012-40", "2012-41", "2012-42", "2012-43"], chart.ticks
    assert_equal [{:color => "#3182bd"}, {:color => "#6baed6"}], chart.series

    assert_equal 2, chart.series_details.length
    assert_equal "Dave Lopper", chart.series_details[0].name
    assert_equal "John Smith", chart.series_details[1].name
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
    assert_equal ["2012-46", "2012-47", "2012-48", "2012-49", "2012-50", "2012-51"], chart.ticks

    assert_equal 2, chart.series_details.length
    assert_equal "Dave Lopper", chart.series_details[0].name
    assert_equal "John Smith", chart.series_details[1].name
  end
end
