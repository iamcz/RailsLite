require_relative '../phase8/controller_base'
require_relative '../phase6/router'
require_relative 'controller_helper'
require_relative 'router_helper'
require_relative 'route_helper'
require_relative 'form_helper'

module Phase9

  class ControllerBase < Phase8::ControllerBase
    include ControllerHelper
    include FormHelper
  end

  class Route < Phase6::Route
    include RouteHelper
  end

  class Router < Phase6::Router
    include RouterHelper
  end

end
