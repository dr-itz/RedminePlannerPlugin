require File.dirname(__FILE__) + '/../test_helper'

class PlannerMailerTest < ActionMailer::TestCase
  include Redmine::I18n

  fixtures :projects, :users, :plan_tasks, :plan_requests, :plan_details

  setup do
    Setting.bcc_recipients = false
  end

  test "send notification on READY" do
    req = PlanRequest.find(5)

    assert_difference('ActionMailer::Base.deliveries.size', +1) do
      PlannerMailer.plan_request_notification(req).deliver
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal ["jsmith@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["dlopper@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_ready, :id => req.id)
    assert_equal subject, email.subject
  end

  test "send notification on APPROVE" do
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_APPROVED

    assert_difference('ActionMailer::Base.deliveries.size', +1) do
      PlannerMailer.plan_request_notification(req).deliver
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal ["dlopper@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["jsmith@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_approved, :id => req.id)
    assert_equal subject, email.subject
  end

  test "send notification on DENIED" do
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_DENIED

    assert_difference('ActionMailer::Base.deliveries.size', +1) do
      PlannerMailer.plan_request_notification(req).deliver
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal ["dlopper@somenet.foo", "dlopper2@somenet.foo"], email.to
    assert_equal ["jsmith@somenet.foo"], email.cc
    subject = "[Planner] " + l(:mail_subject_planner_denied, :id => req.id)
    assert_equal subject, email.subject
  end

  test "no mail on unsupported status" do
    req = PlanRequest.find(5)
    req.status = PlanRequest::STATUS_NEW

    assert_no_difference('ActionMailer::Base.deliveries.size') do
      PlannerMailer.plan_request_notification(req).deliver
    end
    email = ActionMailer::Base.deliveries.last
  end

  test "send notification on DELETED" do
    req = PlanRequest.find(5)

    assert_difference('ActionMailer::Base.deliveries.size', +1) do
      PlannerMailer.plan_request_deleted(req).deliver
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal ["dlopper@somenet.foo", "dlopper2@somenet.foo", "jsmith@somenet.foo"], email.to
    subject = "[Planner] " + l(:mail_subject_planner_deleted, :id => req.id)
    assert_equal subject, email.subject
  end
end
