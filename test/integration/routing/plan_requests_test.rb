require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlanRequestTest < ActionDispatch::IntegrationTest
  def test_plan_requests_scoped_under_project
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_requests" },
        { :controller => 'plan_requests', :action => 'index',
          :project_id => 'foo' })
    assert_routing(
        { :method => 'get', :path => "/projects/foo/plan_requests/new" },
        { :controller => 'plan_requests', :action => 'new',
          :project_id => 'foo' })
    assert_routing(
        { :method => 'post', :path => "/projects/foo/plan_requests" },
        { :controller => 'plan_requests', :action => 'create',
          :project_id => 'foo' })
  end

  def test_plan_requests
    assert_routing(
        { :method => 'get', :path => "/plan_requests/1" },
        { :controller => 'plan_requests', :action => 'show', :id => '1' })
    assert_routing(
        { :method => 'get', :path => "/plan_requests/1/edit" },
        { :controller => 'plan_requests', :action => 'edit', :id => '1' })
    assert_routing(
        { :method => 'put', :path => "/plan_requests/1" },
        { :controller => 'plan_requests', :action => 'update', :id => '1' })
    assert_routing(
        { :method => 'delete', :path => "/plan_requests/1" },
        { :controller => 'plan_requests', :action => 'destroy', :id => '1' })
    assert_routing(
        { :method => 'put', :path => "/plan_requests/1/request" },
        { :controller => 'plan_requests', :action => 'send_request', :id => '1' })
    assert_routing(
        { :method => 'put', :path => "/plan_requests/1/approve" },
        { :controller => 'plan_requests', :action => 'approve', :id => '1' })
  end
end
