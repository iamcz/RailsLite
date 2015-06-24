require_relative '../phase8/controller_base'
require_relative 'route_helper'
require_relative 'form_helper'
require_relative 'helper_methods'

module Phase9
  class ControllerBase < Phase8::ControllerBase
    include FormHelper
    include HelperMethods
    extend RouteHelper
  end

  class Router < Phase6::Router
    def run(req, res)
      route = match(req)
      
      route.controller_class.define_route_helpers(@routes) if route
      super
    end
  end
end
