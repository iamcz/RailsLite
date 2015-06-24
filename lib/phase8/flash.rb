require 'webrick'
require 'json'

class Flash
  def initialize(req)
    flash_cookie = req.cookies.find { |c| c.name == 'FLASH' }
    @request_flash_hash = JSON.parse(flash_cookie.value) if flash_cookie
    @request_flash_hash ||= {}
  end

  def now
    @request_flash_hash
  end

  def [](key)
    if @request_flash_hash[key]
      @request_flash_hash[key]
    else
      @request_flash_hash[key.to_s]
    end
  end

  def []=(key, value)
    @response_flash_hash ||= {}
    @response_flash_hash[key.to_s] = value
  end

  def store_flash(res)
    res.cookies << WEBrick::Cookie.new('FLASH', @response_flash_hash.to_json)
  end
end
