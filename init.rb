require 'redmine'
require 'planner/hooks'
require 'planner/planner_projects_helper_patch'

Redmine::Plugin.register :planner do
  name 'Planner'
  author 'Daniel Ritz'
  description 'Redmine Resource Planner Plugin'
  version '0.4'
  url 'https://github.com/dr-itz/RedminePlannerPlugin'
  author_url 'mailto:daniel.ritz@gmx.ch'
  requires_redmine :version_or_higher => '2.0.3'

  project_module :planner do
    permission :planner_view, {
      :planner => [:index],
      :plan_charts => [:show_user, :show_group, :show_task],
      :plan_groups => [:index, :show],
      :plan_tasks => [:index, :show],
      :plan_requests => [:index, :show],
      :plan_details => [:index, :show]
    }

    permission :planner_requests, {
      :plan_requests => [
        :new, :create, :edit, :update, :destroy, :send_request, :approve],
      :plan_details => [:index, :create, :destroy]
    }

    permission :planner_task_create, {
      :plan_tasks => [:new, :create, :edit, :update]
    }

    permission :planner_admin, {
      :planner => [:index],
      :plan_charts => [:show_user, :show_group, :show_task],
      :plan_groups => [
        :index, :show, :new, :create, :edit, :update, :destroy,
        :remove_membership, :add_membership
      ],
      :plan_tasks => [
        :index, :show, :new, :create, :edit, :update, :destroy],
      :plan_requests => [
        :index, :show, :new, :create, :edit, :update, :destroy, :send_request, :approve],
      :plan_details => [:index, :create, :destroy],
      :planner_config => [:show, :update]
    }
  end

  menu :project_menu, :planner,
    { :controller => 'planner', :action => 'index' },
    :caption => :label_planner_menu_main, :param => :project_id

  Rails.configuration.to_prepare do
    require_dependency 'projects_helper'
    unless ProjectsHelper.included_modules.include? PlannerProjectsHelperPatch
      ProjectsHelper.send(:include, PlannerProjectsHelperPatch)
    end
  end
end
