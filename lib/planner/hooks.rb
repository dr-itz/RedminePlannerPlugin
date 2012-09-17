module RedminePlanner
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      if Redmine::VERSION::MAJOR == 2 && Redmine::VERSION::MINOR < 1
        javascript_include_tag("jquery-1.7.2.min.js", :plugin => :planner) +
          %(<script type="text/javascript">//<![CDATA[\njQuery.noConflict();\n//]]></script>).html_safe
      else
        ""
      end
    end
  end
end
