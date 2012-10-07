require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlannerTest < ActionController::IntegrationTest
  def test_planner_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner" },
        { :controller => 'planner', :action => 'index',
          :project_id => 'foo' })
    assert_routing(
        { :method => 'get', :path => "/projects/foo/planner/user/3" },
        { :controller => 'planner', :action => 'show_user',
          :project_id => 'foo', :id => '3' })
  end
end
