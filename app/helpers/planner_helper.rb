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
end
