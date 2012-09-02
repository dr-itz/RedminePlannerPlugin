require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlanTaksTest < ActionController::IntegrationTest
  def test_plan_groups_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_groups" },
        { :controller => 'plan_groups', :action => 'index',
          :project_id => 'foo' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_groups/new" },
        { :controller => 'plan_groups', :action => 'new',
          :project_id => 'foo' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/foo/plan_groups" },
        { :controller => 'plan_groups', :action => 'create',
          :project_id => 'foo' }
      )
  end

  def test_plan_groups
    assert_routing(
        { :method => 'get', :path => "/plan_groups/1" },
        { :controller => 'plan_groups', :action => 'show', :id => '1' }
      )
    assert_routing(
        { :method => 'get', :path => "/plan_groups/1/edit" },
        { :controller => 'plan_groups', :action => 'edit', :id => '1' }
      )
    assert_routing(
        { :method => 'put', :path => "/plan_groups/1" },
        { :controller => 'plan_groups', :action => 'update', :id => '1' }
      )
    assert_routing(
        { :method => 'delete', :path => "/plan_groups/1" },
        { :controller => 'plan_groups', :action => 'destroy', :id => '1' }
      )
  end
end
