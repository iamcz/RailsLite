module RouteHelper
  def initialize(pattern, http_method, controller_class, action_name, router)
    super(pattern, http_method, controller_class, action_name)
    @router = router
  end

  def run(req, res)
    match_data = @pattern.match(req.path)
    route_params = {}

    match_data.names.each do |name|
      route_params[name] = match_data[name]
    end
    
    @controller_class
      .new(req, res, route_params, @router)
      .invoke_action(@action_name)
  end
end
