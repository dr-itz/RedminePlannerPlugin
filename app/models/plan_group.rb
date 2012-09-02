class PlanGroup < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :team_leader, :class_name => 'User', :foreign_key => 'leader_id'

  def self.all_project_groups(project)
    self.where(:project_id => project.is_a?(Project) ? project.id : project).order(:name)
  end
end
