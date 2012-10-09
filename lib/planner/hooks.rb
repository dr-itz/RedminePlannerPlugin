module RedminePlanner
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      o = stylesheet_link_tag('planner', :plugin => 'planner')
      if Redmine::VERSION::MAJOR == 2 && Redmine::VERSION::MINOR < 1
        o += javascript_include_tag("jquery-1.7.2.min.js", :plugin => :planner) +
          %(<script type="text/javascript">//<![CDATA[\njQuery.noConflict();\n//]]></script>).html_safe
      end
      o += javascript_include_tag("planner", :plugin => :planner)
      return o
    end
  end
end
