module PlanRequestStateHandling
  def process_request_states
    @inc_ready  = params[:inc_ready]  != "0"
    @inc_new    = params[:inc_new]    == "1"
    @inc_denied = params[:inc_denied] == "1"

    @states = [ PlanRequest::STATUS_APPROVED ]
    @states << PlanRequest::STATUS_READY  if @inc_ready
    @states << PlanRequest::STATUS_NEW    if @inc_new
    @states << PlanRequest::STATUS_DENIED if @inc_denied
  end
end
