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
    permission :view_plan, :planner => :index
  end

  menu :project_menu, :planner,
    { :controller => 'planner', :action => 'index' },
    :caption => :label_menu_main, :param => :project_id
end
