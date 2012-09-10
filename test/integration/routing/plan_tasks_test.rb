require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlanTaksTest < ActionController::IntegrationTest
  def test_plan_tasks_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_tasks" },
        { :controller => 'plan_tasks', :action => 'index',
          :project_id => 'foo' })
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_tasks/new" },
        { :controller => 'plan_tasks', :action => 'new',
          :project_id => 'foo' })
    assert_routing(
        { :method => 'post', :path => "/projects/foo/plan_tasks" },
        { :controller => 'plan_tasks', :action => 'create',
          :project_id => 'foo' })
  end

  def test_plan_tasks
    assert_routing(
        { :method => 'get', :path => "/plan_tasks/1" },
        { :controller => 'plan_tasks', :action => 'show', :id => '1' })
    assert_routing(
        { :method => 'get', :path => "/plan_tasks/1/edit" },
        { :controller => 'plan_tasks', :action => 'edit', :id => '1' })
    assert_routing(
        { :method => 'put', :path => "/plan_tasks/1" },
        { :controller => 'plan_tasks', :action => 'update', :id => '1' })
    assert_routing(
        { :method => 'delete', :path => "/plan_tasks/1" },
        { :controller => 'plan_tasks', :action => 'destroy', :id => '1' })
  end
end
