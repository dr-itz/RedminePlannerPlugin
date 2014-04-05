module RedminePlanner
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      o = stylesheet_link_tag('planner', :plugin => 'planner')
      o += javascript_include_tag("planner", :plugin => :planner)
      return o
    end
  end
end
