require_dependency 'projects_helper'

module PlannerProjectsHelperPatch
  def self.included base
    base.send :include, PlannerProjectsHelperMethods
    base.class_eval do
      alias_method_chain :project_settings_tabs, :planner
    end
  end
end

module PlannerProjectsHelperMethods
  def project_settings_tabs_with_planner
    tabs = project_settings_tabs_without_planner
    tab = {
      :name => 'planner',
      :controller => 'planner_config', :action => :show,
      :partial => 'planner_config/show', :label => :label_planner_menu_main}
    tabs << tab if User.current.allowed_to?(tab, @project)
    tabs
  end
end

ProjectsHelper.send(:include, PlannerProjectsHelperPatch)
