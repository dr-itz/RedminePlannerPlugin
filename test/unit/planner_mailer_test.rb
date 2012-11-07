require File.dirname(__FILE__) + '/../test_helper'

class PlannerMailerTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_tasks, :plan_requests, :plan_details

  setup do
    Setting.bcc_recipients = false
  end

  test "send notification on READY" do
    num = ActionMailer::Base.deliveries.length
    req = PlanRequest.find(5)

    email = PlannerMailer.plan_request_notification(req).deliver
    assert_equal num+1, ActionMailer::Base.deliveries.length

    assert_equal ["jsmith@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["dlopper@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_ready, :id => req.id)
    assert_equal subject, email.subject
  end

  test "send notification on APPROVE" do
    num = ActionMailer::Base.deliveries.length
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_APPROVED

    email = PlannerMailer.plan_request_notification(req).deliver
    assert_equal num+1, ActionMailer::Base.deliveries.length

    assert_equal ["dlopper@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["jsmith@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_approved, :id => req.id)
    assert_equal subject, email.subject
  end

  test "send notification on DENIED" do
    num = ActionMailer::Base.deliveries.length
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_DENIED

    email = PlannerMailer.plan_request_notification(req).deliver
    assert_equal num+1, ActionMailer::Base.deliveries.length

    assert_equal ["dlopper@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["jsmith@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_denied, :id => req.id)
    assert_equal subject, email.subject
  end

  test "no mail on unsupported status" do
    num = ActionMailer::Base.deliveries.length
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_NEW

    email = PlannerMailer.plan_request_notification(req).deliver
    assert_equal num, ActionMailer::Base.deliveries.length
  end
end
