require 'active_support/inflector'

module RouteHelper
  SINGULAR_PATH_ACTIONS = [:show, :update, :destroy]
  PLURAL_PATH_ACTIONS = [:index, :create]

  def method_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_ACTIONS.include?(action)
      class_name
    elsif SINGULAR_PATH_ACTIONS.include?(action)
      class_name.singularize
    elsif action == :edit
      "edit_#{class_name.singularize}"
    elsif action == :new
      "new_#{class_name.singularize}"
    end
  end

  def path_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_ACTIONS.include?(action)
      "/#{class_name}"
    elsif action == :new
      "/#{class_name}/new"
    elsif SINGULAR_PATH_ACTIONS.include?(action) || action == :destroy
      "/#{class_name}/<id>"
    elsif action == :edit
      "/#{class_name}/<id>/edit"
    end
  end

  def define_route_helpers(routes)
    routes.each do |route|
      action = route.action_name
      method_partial = method_for(action)
      path_method = "#{method_partial}_path".to_sym
      url_method = "#{method_partial}_url".to_sym

      unless method_defined?(path_method)
        define_method(path_method) do |args = nil|
          path = self.class.path_for(action)
          
          if args.is_a?(Hash)
            raise 'meta hell' if path.include?("<id>") && !args.keys.include?(:id)
            path.gsub!("<id>", args[:id].to_s)
          elsif args
            raise 'meta hell' if path.include?("<id>") && !args.respond_to?(:id)
            path.gsub!("<id>", args.send(:id).to_s)
          end

          path
        end
      end
      
      unless method_defined?(url_method)
        define_method(url_method) do |args = nil|
          "http://" + @req.host + self.send(path_method, args)
        end
      end
    end
  end
end
