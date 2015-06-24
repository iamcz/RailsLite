require_relative '../phase6/controller_base'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    def initialize(req, res, route_params = {})
      @flash # = Flash.new
      super
    end
  end
end
