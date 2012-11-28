require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlanChartsTest < ActionController::IntegrationTest
  def test_planner_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner/user/3" },
        { :controller => 'plan_charts', :action => 'show_user',
          :project_id => 'foo', :id => '3' })
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner/group/3" },
        { :controller => 'plan_charts', :action => 'show_group',
          :project_id => 'foo', :id => '3' })
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner/task/3" },
        { :controller => 'plan_charts', :action => 'show_task',
          :project_id => 'foo', :id => '3' })
  end
end
