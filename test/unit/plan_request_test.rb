require File.dirname(__FILE__) + '/../test_helper'

class PlanRequestTest < ActiveSupport::TestCase
  fixtures :projects, :users, :plan_tasks, :plan_requests

  test "create new" do
    tmp = PlanRequest.new(
      :requester => User.find(2), :resource => User.find(3), :task => PlanTask.find(1))
    assert tmp.save
  end
end
