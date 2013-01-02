module PlannerHelper
  def link_to_user_plan_view(project, user, opts = {})
    name = h(user.name)
    link_to name, planner_show_user_path(project, user, opts)
  end

  def link_to_group_plan_view(project, group, opts = {})
    name = h(group.name)
    link_to name, planner_show_group_path(project, group, opts)
  end

  def link_to_task_plan_view(task, opts = {})
    link_to task.name, planner_show_task_path(task.project, task, opts)
  end

  def request_states_link_args(states)
    ret = {}
    ret[:inc_ready] = "0" unless states.include? PlanRequest::STATUS_READY
    ret[:inc_new] = "1" if states.include? PlanRequest::STATUS_NEW
    ret[:inc_denied] = "1" if states.include? PlanRequest::STATUS_DENIED
    ret
  end

  def chart_link_args(chart, states)
    ret = {:start => chart.start_date.to_s, :weeks => chart.weeks}
    ret = ret.merge request_states_link_args(states)
    ret
  end
end
