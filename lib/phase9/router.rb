require 'active_support/inflector'

module Phase9
  SINGULAR_PATH_ACTIONS = [:show, :update, :destroy]
  PLURAL_PATH_ACTIONS = [:index, :create]
  HOST = 'localhost' # should really get this from http server

  class Router
    class << self
      def partial_name_for(controller, action)
        controller_name = controller.to_s.underscore.chomp('_controller')

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

      def path_for(controller, action)
        class_name = controller.to_s.underscore.chomp("_controller")

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

      def path_sub(path, arg)
        if arg.is_a?(Hash)
          raise 'meta hell' unless arg.keys.include?(:id)
          path.gsub!("<id>", arg[:id])
        elsif arg
          raise 'meta hell' unless arg.respond_to?(:id)
          path.gsub!("<id>", arg.send(:id))
        else
          raise 'meta hell'
        end

        path
      end
    end

    def initialize
      super

      @helpers = []
    end

    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name, self)

      self.define_helpers_for(controller_class, action_name)
    end

    private

    def define_helpers_for(controller, action)
      method_partial = partial_name_for(controller, action)
      path_method = "#{method_partial}_path".to_sym
      url_method = "#{method_partial}_url".to_sym

      unless self.singleton_methods.include?(path_method)
        self.define_singleton_method(path_method) do |arg=nil|
          path = path_for(controller, action)

          if path.include?("<id>")
            self.class.path_sub(path, arg)
          end

          path
        end
      end
      
      unless self.singleton_methods.include?(url_method)
        self.define_singleton_method(url_method) do |arg=nil|
          path = self.send(path_method)

          "http://" + HOST + self.send(path_method, arg)
        end
      end
    end
  end

  class Route
    def initialize(pattern, http_method, controller_class, action_name, router)
      super(pattern, http_method, controller_class, action_name)
      @router = router
    end

    def run(req, res)
      match_data = @pattern.match(req.path)
      route_params = {}

      match_data.names.each do |name|
        route_params[name] = match_data[name]
      end
      
      @controller_class
        .new(req, res, route_params, @router)
        .invoke_action(@action_name)
    end
  end
end
