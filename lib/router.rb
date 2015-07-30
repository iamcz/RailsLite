require_relative 'route'
require_relative 'router_helper'

class Router
  HOST = 'localhost' # should really get this from http server

  extend RouterHelper

  attr_reader :routes, :helpers

  def initialize
    @routes = []
    @hepers = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name, self)

    define_helpers_for(controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    route = match(req)

    route ? route.run(req, res) : res.status = 404
  end

  private

  def define_helpers_for(controller, action)
    method_partial = Router.partial_name_for(controller, action)
    path_method = "#{method_partial}_path".to_sym
    url_method = "#{method_partial}_url".to_sym

    unless self.singleton_methods.include?(path_method)
      define_path_helper(controller, action)
      @helpers << path_method
    end
    
    unless self.singleton_methods.include?(url_method)
      define_url_helper(controller, action)
      @helpers << url_method
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
