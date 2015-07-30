class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name, router)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
    @router = router
  end

  def matches?(req)
    req.request_method.downcase.to_sym == @http_method && @pattern.match(req.path)
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
