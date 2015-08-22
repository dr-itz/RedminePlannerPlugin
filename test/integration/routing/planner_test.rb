require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlannerTest < ActionDispatch::IntegrationTest
  def test_planner_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner" },
        { :controller => 'planner', :action => 'index',
          :project_id => 'foo' })
  end
end
