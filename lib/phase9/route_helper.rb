require 'active_support/inflector'

module RouteHelper
  def define_route_helpers(routes)
    routes.each do |route|
      controller_name = route.controller_class.to_s.underscore.chomp('_controller')
      action_name = route.action_name
      method_partial = "#{controller_name}_#{action_name}"

      # Can this be prettier?
      define_method("#{method_partial}_path".to_sym) do |args = nil|
        # Replace all regex garbage
        path_str = route.pattern.to_s
          .gsub("(?-mix:^","")
          .gsub("$)","")
          .gsub("\\","")
          .gsub("?","")
          .gsub("d+","")
        
        # Replace all variables
        if args.is_a?(Hash)
          route_params = args
          route_params.each do |name, value|
            path_str.gsub!("(<#{name}>)", value.to_s)
          end
        elsif !args.nil?
          obj = args
          route.pattern.names.each do |name|
            value = obj.send(name.to_sym)
            path_str.gsub!("(<#{name}>)", value.to_s)
          end
        end

        path_str
      end

      define_method("#{method_partial}_url".to_sym) do |args = nil|
        # Use path method defined above
        # "http://#{@req.host}#{self.send("#{method_partial}_path".to_sym, args)}"
        # debugger
        "http://" + @req.host + self.send("#{method_partial}_path".to_sym, args)
      end

    end
  end
end
