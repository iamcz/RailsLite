require_relative '../phase8/controller_base.rb'
require_relative 'route_helper'

module Phase9
  class BaseController < Phase8::BaseController
    include RouteHelper
  end
end
