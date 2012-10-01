require File.dirname(__FILE__) + '/../../test_helper'

class RoutingPlanDetailsTest < ActionController::IntegrationTest
  def test_plan_details_scoped_under_plan_requests
    assert_routing(
        { :method => 'get', :path => "/plan_requests/1/plan_details" },
        { :controller => 'plan_details', :action => 'index',
          :plan_request_id => '1' })
    assert_routing(
        { :method => 'post', :path => "/plan_requests/1/plan_details" },
        { :controller => 'plan_details', :action => 'create',
          :plan_request_id => '1' })
    # action => "new" is not used
  end

  def test_plan_requests
    # action => "show" is not used
    # action => "edit" is not used
    # action => "update" is not used
    assert_routing(
        { :method => 'delete', :path => "/plan_details/1" },
        { :controller => 'plan_details', :action => 'destroy', :id => '1' })
  end
end
