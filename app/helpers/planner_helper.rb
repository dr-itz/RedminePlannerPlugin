module PlannerHelper
  def link_to_user_plan_view(project, user)
    name = h(user.name)
    link_to name, planner_show_user_path(project, user)
  end
end
