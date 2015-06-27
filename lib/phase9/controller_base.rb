require_relative '../phase8/controller_base'
require_relative '../phase6/router'
require_relative 'router_helper'
require_relative 'form_helper'

module Phase9

  class ControllerBase < Phase8::ControllerBase
    include FormHelper

    def initialize(req, res, router, route_params={})
      super(req, res, route_params)
      
      @router = router
      define_router_helpers
    end

    private

    def define_router_helpers
      @router.helpers.each do |helper|
        # we are defining the helpers on JUST THIS instance of the controller
        self.define_singleton_method(helper) do |arg=nil|
          @router.send(helper, arg)
        end
      end
    end
  end

end
