module PlanChartsHelper
  def chart_link_args(chart, states)
    ret = {:start => chart.start_date.to_s, :weeks => chart.weeks}
    ret[:inc_ready]  = "1" if states.include? PlanRequest::STATUS_READY
    ret[:inc_new]    = "1" if states.include? PlanRequest::STATUS_NEW
    ret[:inc_denied] = "1" if states.include? PlanRequest::STATUS_DENIED
    ret
  end
end
