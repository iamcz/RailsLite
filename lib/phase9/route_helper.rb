require 'active_support/inflector'

module RouteHelper
  def define_route_helpers(routes)
    routes.each do |route|
      controller_name = router.controller_class.to_s.underscore
      action_name = route.action_name
      method_partial = "#{controller_name}_#{action_name}"

      # Can this be prettier?
      define_method("#{method_partial}_path".to_sym) do |obj = nil, route_params = {}|
        return if obj # NOT IMPLEMENTED YET

        # Replace all regex garbage
        path_str = route.pattern.to_s
          .gsub("(?-mix:^","")
          .gsub("$)","")
          .gsub("\\","")
          .gsub("?","")
          .gsub("d+","")
        
        # Replace all variables
        if obj
          route.pattern.names.each do |name|
            value = obj.send(name.to_sym)
            path_str.gsub!("(<#{name}>)", value)
          end
        else
          route_params.each do |name, value|
            path_str.gsub!("(<#{name}>)", value)
          end
        end

        path_str
      end

      define_method("#{method_partial}_url".to_sym) do |obj = nil, route_params = {}|
        # Use path method defined above
        # "http://#{@req.host}#{self.send("#{method_partial}_path".to_sym, obj, route_params)}"
        "http://" + @req.host + self.send("#{method_partial}_path".to_sym, obj, route_params)
      end

    end
  end
end
