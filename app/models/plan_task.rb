# == Schema Information
#
# Table name: plan_tasks
#
#  id          :integer          not null, primary key
#  project_id  :integer          default(0), not null
#  name        :string(255)      not null
#  is_open     :boolean          default(TRUE), not null
#  task_type   :integer          default(0), not null
#  owner_id    :integer          default(0), not null
#  description :string(255)
#  wbs         :string(255)
#  parent_task :integer
#

class PlanTask < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  if Redmine::VERSION::MAJOR == 3
    has_many :requests, :class_name => 'PlanRequest', :foreign_key => 'task_id', :dependent => :restrict_with_exception
  else
    has_many :requests, :class_name => 'PlanRequest', :foreign_key => 'task_id', :dependent => :restrict
  end

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]

  attr_protected :project

  # Returns all PlanTasks belonging to the specified +project+
  scope :all_project_tasks, lambda { |project|
    where(:project_id => project.is_a?(Project) ? project.id : project).order(:name)
  }

  scope :assignable, lambda { where(:is_open => true) }

  def can_edit?
    current = User.current
    owner == current || current.allowed_to?(:planner_admin, project)
  end

  def can_delete?
    can_edit? && requests.empty?
  end
end
