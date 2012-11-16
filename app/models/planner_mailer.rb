class PlannerMailer < Mailer
  # sends a mail notification when the status of a +request+ changes
  def plan_request_notification(request)
    @request = request
    @request_url = url_for(:controller => 'plan_requests', :action => 'show', :id => request.id)

    case request.status
    when PlanRequest::STATUS_READY
      @status = l(:mail_subject_planner_ready, :id => request.id)
      recipients = [request.approver, request.resource]
      @author = request.requester
    when PlanRequest::STATUS_APPROVED
      @status = l(:mail_subject_planner_approved, :id => request.id)
      recipients = [request.requester, request.resource]
      @author = request.approver
    when PlanRequest::STATUS_DENIED
      @status = l(:mail_subject_planner_denied, :id => request.id)
      recipients = [request.requester, request.resource]
      @author = request.approver
    else
      @status = ""
      return mail :to => "", :subject => "dummy"
    end

    cc = @author.pref[:no_self_notified] ? "" : @author.mail
    mail :to => recipients.collect(&:mail), :cc => cc, :subject => "[Planner] " + @status
  end

  def plan_request_deleted(request)
    @request = request
    @status = l(:mail_subject_planner_deleted, :id => request.id)
    recipients = [request.requester, request.resource, request.approver]
    mail :to => recipients.collect(&:mail), :subject => "[Planner] " + @status
  end
end
