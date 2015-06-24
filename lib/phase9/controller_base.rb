require_relative '../phase8/controller_base.rb'
require_relative 'route_helper'
require_relative 'form_helper'

module Phase9
  class BaseController < Phase8::BaseController
    extend RouteHelper
    include FormHelper
  end

  class Router < Phase6::Router
  end
end
