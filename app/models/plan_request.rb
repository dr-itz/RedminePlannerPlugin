# == Schema Information
#
# Table name: plan_requests
#
#  id             :integer          not null, primary key
#  requester_id   :integer          default(0), not null
#  resource_id    :integer          default(0), not null
#  approver_id    :integer          default(0)
#  task_id        :integer          default(0), not null
#  req_type       :integer          default(0), not null
#  priority       :integer          default(3), not null
#  description    :text
#  status         :integer          default(0), not null
#  requested_on   :datetime
#  approved_on    :datetime
#  approver_notes :text
#

class PlanRequest < ActiveRecord::Base
  unloadable

  include Redmine::I18n

  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :resource,  :class_name => 'User', :foreign_key => 'resource_id'
  belongs_to :approver,  :class_name => 'User', :foreign_key => 'approver_id'

  belongs_to :task,  :class_name => 'PlanTask', :foreign_key => 'task_id'

  has_many :details, :class_name => 'PlanDetail', :foreign_key => 'request_id', :dependent => :destroy

  attr_protected :requested_on, :approver_id, :approved_on, :status, :approver_notes

  before_destroy :destroy_notification

  STATUS_NEW = 0
  STATUS_READY = 1
  STATUS_APPROVED = 2
  STATUS_DENIED = 3

  PRIO_LOWEST = 1
  PRIO_LOW = 2
  PRIO_NORMAL = 3
  PRIO_HIGH = 4
  PRIO_HIGHEST = 5

  validates_inclusion_of :status, :in => [STATUS_NEW, STATUS_READY, STATUS_APPROVED, STATUS_DENIED]
  validates_inclusion_of :priority, :in => [PRIO_LOWEST, PRIO_LOW, PRIO_NORMAL, PRIO_HIGH, PRIO_HIGHEST]

  # Returns the status as i18n string
  def status_string
    case status
      when STATUS_NEW      then l(:label_planner_req_status_new)
      when STATUS_READY    then l(:label_planner_req_status_ready)
      when STATUS_APPROVED then l(:label_planner_req_status_approved)
      when STATUS_DENIED   then l(:label_planner_req_status_denied)
      else ""
    end
  end

  # Returns an array of priorities for ERB select
  def self.priority_select
    [
      [ l(:label_planner_req_prio_lowest),  PRIO_LOWEST ],
      [ l(:label_planner_req_prio_low),     PRIO_LOW ],
      [ l(:label_planner_req_prio_normal),  PRIO_NORMAL ],
      [ l(:label_planner_req_prio_high),    PRIO_HIGH ],
      [ l(:label_planner_req_prio_highest), PRIO_HIGHEST ]
    ]
  end

  # Returns the priority as i18n string
  def priority_string
    case priority
      when PRIO_LOWEST  then l(:label_planner_req_prio_lowest)
      when PRIO_LOW     then l(:label_planner_req_prio_low)
      when PRIO_NORMAL  then l(:label_planner_req_prio_normal)
      when PRIO_HIGH    then l(:label_planner_req_prio_high)
      when PRIO_HIGHEST then l(:label_planner_req_prio_highest)
      else ""
    end
  end

  scope :all_project_requests, lambda { |project|
    includes(:task, :requester, :resource, :approver).where(
      "plan_tasks.project_id = :project_id",
      :project_id => project.is_a?(Project) ? project.id : project).order(
        'plan_requests.id')
  }

  scope :all_open_requests_requester, lambda { |project|
    all_project_requests(project).where(
      :requester_id => User.current.id, :status => [STATUS_NEW, STATUS_READY, STATUS_DENIED])
  }

  scope :all_open_requests_approver, lambda { |project|
    all_project_requests(project).where(
      :approver_id => User.current.id, :status => STATUS_READY)
  }

  scope :all_open_requests_requestee, lambda { |project|
    all_project_requests(project).where(
      :resource_id => User.current.id, :status => STATUS_READY)
  }

  def send_request
    self.approver = PlanGroup.find_teamleader(resource)
    self.requested_on = DateTime.current
    self.status = STATUS_READY
    save

    PlannerMailer.plan_request_notification(self).deliver
  end

  def approve_deny_request(new_status, note)
    new_status = new_status.to_i
    return false unless (new_status == STATUS_APPROVED) || (new_status == STATUS_DENIED)

    self.approved_on = DateTime.current
    self.status = new_status
    self.approver_notes = note
    save

    PlannerMailer.plan_request_notification(self).deliver

    true
  end

  def can_edit?
    User.current == requester && (status == STATUS_NEW || status == STATUS_DENIED)
  end

  def can_request?
    can_edit?
  end

  def can_approve?
    User.current == approver && status == STATUS_READY
  end

private

  def destroy_notification
    return if (status == STATUS_NEW)
    PlannerMailer.plan_request_deleted(self).deliver
  end
end
