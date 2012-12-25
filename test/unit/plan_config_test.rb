
require File.dirname(__FILE__) + '/../test_helper'

class PlanConfigTest < ActiveSupport::TestCase
  fixtures :projects, :plan_configs

  test "existing config" do
    config = PlanConfig.project_config(2)

    assert_equal 100, config[:workload_target].to_i
    assert_equal  80, config[:workload_threshold_ok].to_i
    assert_equal 110, config[:workload_threshold_overload].to_i
    assert_equal  10, config[:graph_weeks].to_i
    assert_equal   3, config[:graph_weeks_past].to_i
  end

  test "new config" do
    config = PlanConfig.project_config(1)

    assert_equal 100, config[:workload_target].to_i
    assert_equal  80, config[:workload_threshold_ok].to_i
    assert_equal 110, config[:workload_threshold_overload].to_i
    assert_equal   8, config[:graph_weeks].to_i
    assert_equal   1, config[:graph_weeks_past].to_i
  end

  test "set attributes" do
    config = PlanConfig.project_config(1)

    config[:workload_target] = 120
    config['workload_threshold_ok'] = 100
    assert_equal 120, config['workload_target'].to_i
    assert_equal 100, config[:workload_threshold_ok].to_i
  end

  test "update attributes" do
    config = PlanConfig.project_config(2)
    config.update_config({ :workload_target => 120, :workload_threshold_ok => 100 })

    # reload...
    config = PlanConfig.project_config(2)
    assert_equal 120, config[:workload_target].to_i
    assert_equal 100, config[:workload_threshold_ok].to_i
  end
end
