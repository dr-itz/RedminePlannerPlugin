class PlannerMailer < Mailer
  # sends mails when a resource +request+ is ready. to: approver, resource
  def request_ready(request)
    recipients = []
    recipients << request.approver
    recipients << request.resource
    @request = request

    subject = l(:mail_subject_planner_ready, :id => request.id)
    mail :to => recipients.collect(&:mail), :subject => subject
  end

  # sends mails when a resource +request+ is approved. to: requester, resource
  def request_approved(request)
    recipients = []
    recipients << request.requester
    recipients << request.resource
    @request = request

    subject = l(:mail_subject_planner_approved, :id => request.id)
    mail :to => recipients.collect(&:mail), :subject => subject
  end

  # sends mails when a resource +request+ is denied. to: requester, resource
  def request_denied(request)
    recipients = []
    recipients << request.requester
    recipients << request.resource
    @request = request

    subject = l(:mail_subject_planner_denied, :id => request.id)
    mail :to => recipients.collect(&:mail), :subject => subject
  end

end
