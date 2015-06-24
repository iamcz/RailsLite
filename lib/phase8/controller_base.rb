require_relative '../phase6/controller_base'
require_relative 'flash'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    def initialize(req, res, route_params = {})
      super
    end

    def flash
      @flash ||= Flash.new(req)
    end

    def render_content(content, content_type)
      super
      flash.store_flash(@res)
    end
  end
end
