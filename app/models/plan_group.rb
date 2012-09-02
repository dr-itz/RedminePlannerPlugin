class PlanGroup < ActiveRecord::Base
  unloadable

  include Redmine::I18n

  belongs_to :project
  belongs_to :team_leader, :class_name => 'User', :foreign_key => 'leader_id'

  TYPE_TEAM = 1
  TYPE_GROUP = 2

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]
  validates_inclusion_of :group_type, :in => [TYPE_TEAM, TYPE_GROUP]

  # Returns all PlanGroups belonging to the specified +project+
  def self.all_project_groups(project)
    self.where(:project_id => project.is_a?(Project) ? project.id : project).order(:name)
  end

  # Returns an array of group types for ERB select
  def self.group_types_select
    [[ l(:label_planner_group_team), TYPE_TEAM ], [ l(:label_planner_group_group), TYPE_GROUP ]]
  end

  # Returns the group_type as i18n string
  def type_string
    group_type == TYPE_TEAM ? l(:label_planner_group_team) : l(:label_planner_group_group)
  end
end
