require 'redmine'

Redmine::Plugin.register :planner do
  name 'Planner plugin'
  author 'Daniel Ritz'
  description 'Redmine Resource Planner Plugin'
  version '0.0.1'
  url 'http://github.com/dr-itz/RedminePlannerPlugin'
  author_url 'mailto:daniel.ritz@gmx.ch'
  requires_redmine :version_or_higher => '2.0.2'

  project_module :planner do
    permission :planner_view, {
      :planner => :index,
      :plan_groups => [:index, :show],
      :plan_tasks => [:index, :show]
	  }

    permission :planner_admin, {
      :plan_groups => [:index, :show, :new, :create, :edit, :update, :destroy],
      :plan_tasks => [:index, :show, :new, :create, :edit, :update, :destroy]
    }
  end

  menu :project_menu, :planner,
    { :controller => 'planner', :action => 'index' },
    :caption => :label_planner_menu_main, :param => :project_id
end
