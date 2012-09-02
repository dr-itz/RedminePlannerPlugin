require File.dirname(__FILE__) + '/../test_helper'

class PlanGroupTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_groups

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

  test "type_string i18n for team" do
    tmp = PlanGroup.new
    tmp.group_type = PlanGroup::TYPE_TEAM
    assert_equal l(:label_planner_group_team), tmp.type_string
  end

  test "type_string i18n for group" do
    tmp = PlanGroup.new
    tmp.group_type = PlanGroup::TYPE_GROUP
    assert_equal l(:label_planner_group_group), tmp.type_string
  end

  test "create new" do
    tmp = PlanGroup.new(
      :project => Project.find(1), :name => 'New team', :group_type => PlanGroup::TYPE_TEAM,
      :team_leader => User.find(2))
    assert tmp.save
  end

  test "validations" do
    # duplicate name for project 1, invalid group_type
    tmp = PlanGroup.new(
      :project => Project.find(1), :name => 'Team 1', :group_type => 7, :team_leader => User.find(2))
    assert !tmp.valid?
    assert tmp.errors[:name]
    assert tmp.errors[:group_type]
  end
end
