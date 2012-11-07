class PlannerMailer < Mailer
  # sends a mail notification when the status of a +request+ changes
  def plan_request_notification(request)
    case request.status
    when PlanRequest::STATUS_READY
      subject = l(:mail_subject_planner_ready, :id => request.id)
      recipients = [request.approver, request.resource]
      @author = request.requester
    when PlanRequest::STATUS_APPROVED
      subject = l(:mail_subject_planner_approved, :id => request.id)
      recipients = [request.requester, request.resource]
      @author = request.approver
    when PlanRequest::STATUS_DENIED
      subject = l(:mail_subject_planner_denied, :id => request.id)
      recipients = [request.requester, request.resource]
      @author = request.approver
    else
      return false
    end

    @request = request
    recipients << @author unless @author.pref[:no_self_notified]
    mail :to => recipients.collect(&:mail), :subject => "[Planner] " + subject
  end
end
