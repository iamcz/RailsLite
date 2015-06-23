require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
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
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
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
end
