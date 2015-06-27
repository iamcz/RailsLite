require_relative '../phase6/router'
require_relative 'router_helper'
require_relative 'route'

module Phase9
  HOST = 'localhost' # should really get this from http server

  class Router < Phase6::Router
    extend RouterHelper
    attr_reader :helpers

    def initialize
      super

      @helpers = []
    end

    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name, self)

      # debugger
      define_helpers_for(controller_class, action_name)
    end

    private

    def define_helpers_for(controller, action)
      method_partial = Router.partial_name_for(controller, action)
      path_method = "#{method_partial}_path".to_sym
      url_method = "#{method_partial}_url".to_sym

      unless self.singleton_methods.include?(path_method)
        define_path_helper(controller, action)
        @helpers << path_method
        # self.define_singleton_method(path_method) do |arg=nil|
        #   path = path_for(controller, action)

        #   if path.include?("<id>")
        #     self.class.path_sub(path, arg)
        #   end

        #   path
        # end
      end
      
      unless self.singleton_methods.include?(url_method)
        define_url_helper(controller, action)
        @helpers << url_method
        # self.define_singleton_method(url_method) do |arg=nil|
        #   path = self.send(path_method)

        #   "http://" + HOST + self.send(path_method, arg)
        # end
      end
    end

    def define_path_helper(controller, action)
      method_partial = Router.partial_name_for(controller, action)
      path_method = "#{method_partial}_path".to_sym

      self.define_singleton_method(path_method) do |arg=nil|
        path = Router.path_for(controller, action)

        if path.include?("<id>")
          self.class.path_sub(path, arg)
        end

        path
      end
    end

    def define_url_helper(controller, action)
      method_partial = Router.partial_name_for(controller, action)
      path_method = "#{method_partial}_path".to_sym
      url_method = "#{method_partial}_url".to_sym

      self.define_singleton_method(url_method) do |arg=nil|
        "http://" + HOST + self.send(path_method, arg)
      end
    end
  end
end
