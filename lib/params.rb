class Params
  def initialize(req, route_params = {})
    @params = route_params
    @params = @params.merge(parse_www_encoded_form(req.query_string || ""))
    @params = @params.merge(parse_www_encoded_form(req.body || ""))
  end

  def [](key)
    @params[key.to_s]
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  def parse_www_encoded_form(www_encoded_form)
    form_array = URI::decode_www_form(www_encoded_form)

    params_hash = {}
    
    form_array.each do |key, value|
      names = parse_key(key)

      current_hash = params_hash
      
      (0...names.length-1).each do |i|
        current_hash[names[i]] ||= {}
        current_hash = current_hash[names[i]]
      end
    
      current_hash[names.last] = value
    end

    params_hash
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
