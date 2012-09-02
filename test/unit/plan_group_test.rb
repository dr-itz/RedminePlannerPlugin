require File.dirname(__FILE__) + '/../test_helper'

class PlanGroupTest < ActiveSupport::TestCase
  fixtures :projects, :plan_groups

  test "all_project_groups project 1" do
    project = Project.find(1)
    filtered = PlanGroup.all_project_groups(project)
    assert_equal 2, filtered.length
    assert_equal 1, filtered[0].project_id
    assert_equal 1, filtered[1].project_id
  end

  test "all_project_groups project 2" do
    filtered = PlanGroup.all_project_groups(2)
    assert_equal 1, filtered.length
    assert_equal 2, filtered[0].project_id
  end
end
