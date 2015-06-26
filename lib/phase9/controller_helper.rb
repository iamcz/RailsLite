module ControllerHelper

  def initialize(req, res, route_params, router)
    super(req, res, route_params)
    
    @router = router
    define_helpers_from(router)
  end

  private

  def define_helpers_for(router)
    router.helpers.each do |helper|
      # we are defining the helpers on JUST THIS instance of the controller
      self.define_singleton_method(helper) do
        @router.send(helper)
      end
    end
  end

end
