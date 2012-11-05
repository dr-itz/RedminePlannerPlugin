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

end
