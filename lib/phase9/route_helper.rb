require 'active_support/inflector'

module RouteHelper
  def define_route_helpers(routes)
    routes.each do |route|
      controller_name = router.controller_class.to_s.underscore
      action_name = route.action_name
      method_partial = "#{controller_name}_#{action_name}_"

      define_method("#{method_partial}_path") do |obj = nil|
        return if obj # NOT IMPLEMENTED YET
      end
    end
  end
end
