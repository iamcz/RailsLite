require 'active_support/inflector'

module RouteHelper
  SINGULAR_PATH_METHODS = [:show, :update, :destroy]
  PLURAL_PATH_METHODS = [:index, :create]

  def define_route_helpers(routes)
    routes.each do |route|
      # controller_name = route.controller_class.to_s.underscore.chomp('_controller')
      # action_name = route.action_name
      # method_partial = "#{controller_name}_#{action_name}"

      # # Can this be prettier?
      # define_method("#{method_partial}_path".to_sym) do |args = nil|
      #   # Replace all regex garbage
      #   path_str = route.pattern.to_s
      #     .gsub("(?-mix:^","")
      #     .gsub("$)","")
      #     .gsub("\\","")
      #     .gsub("?","")
      #     .gsub("d+","")
      #   
      #   # Replace all variables
      #   if args.is_a?(Hash)
      #     route_params = args
      #     route_params.each do |name, value|
      #       path_str.gsub!("(<#{name}>)", value.to_s)
      #     end
      #   elsif !args.nil?
      #     obj = args
      #     route.pattern.names.each do |name|
      #       value = obj.send(name.to_sym)
      #       path_str.gsub!("(<#{name}>)", value.to_s)
      #     end
      #   end

      #   path_str
      # end

      # define_method("#{method_partial}_url".to_sym) do |args = nil|
      #   # Use path method defined above
      #   # "http://#{@req.host}#{self.send("#{method_partial}_path".to_sym, args)}"
      #   # debugger
      #   "http://" + @req.host + self.send("#{method_partial}_path".to_sym, args)
      # end

      action = route.action_name
      method_partial = method_for(action)
      path_method = "#{method_partial}_path".to_sym
      url_method = "#{method_partial}_url".to_sym

      unless method_defined?(path_method)
        define_method(path_method) do |args = nil|
          path = path_for(action)
          
          if args.is_a?(Hash)
            raise 'meta hell' if path.include?("<id>") && !args.keys.include?(:id)
            path.gsub("<id>", args[:id])
          elsif args
            raise 'meta hell' if path.include?("<id>") && !args.respond_to?(:id)
            path.gsub("<id>", args.send(:id))
          end
        end
      end
      
      unless method_defined?(url_method)
        define_method(url_method) do |args = nil|
          "http://" + @req.host + self.send(path_method, args)
        end
      end

    end
  end

  def path_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_NAMES.include?(action)
      "/#{class_name}"
    elsif SINGULAR_PATH_METHODS.include?(action) || action == :destroy
      "/#{class_name}/<id>"
    elsif action == :edit
      "/#{class_name}/<id>/edit"
    elsif action == :new
      "/#{class_name}/<id>/new"
    end
  end

  def method_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_NAMES.include?(action)
      class_name
    elsif SINGULAR_PATH_METHODS.include?(action)
      class_name.singularize
    elsif action == :edit
      "edit_#{class_name.singularize}"
    elsif action == :new
      "new_#{class_name.singularize}"
    end
  end
end
