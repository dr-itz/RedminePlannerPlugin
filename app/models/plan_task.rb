class PlanTask < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]

  # Returns all PlanTasks belonging to the specified +project+
  scope :all_project_tasks, lambda { |project|
    where(:project_id => project.is_a?(Project) ? project.id : project).order(:name)
  }

  def can_edit?
    current = User.current
    owner == current || current.allowed_to?(:planner_admin, project)
  end
end
