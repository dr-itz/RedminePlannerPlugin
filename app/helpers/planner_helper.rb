module PlannerHelper
  def link_to_user_plan_view(project, user, opts = {})
    name = h(user.name)
    link_to name, planner_show_user_path(project, user, opts)
  end

  def link_to_group_plan_view(project, group)
    name = h(group.name)
    link_to name, planner_show_group_path(project, group)
  end
end
