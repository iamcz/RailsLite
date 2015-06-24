require 'webrick'
require 'json'

class Flash
  def initialize(req)
    flash_cookie = req.cookies.find { |c| c.name == 'FLASH' }
    @cookie_hash = JSON.parse(flash_cookie.value)
  end

  def [](key)
    @cookie_hash[key]
  end

  def []=(key, value)
    @cookie_hash[key] = value
  end

  def store_flash(res)
    res.cookies << Cookie.new('FLASH', @cookie_hash.to_json)
  end
end
