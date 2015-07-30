require 'json'
require 'webrick'

class Session
  APP_NAME = '_rails_lite_app'

  def initialize(req)
    cookie = req.cookies.find { |c| c.name == APP_NAME }
    @session_cookie = cookie ? JSON.parse(cookie.value) : {}
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new(APP_NAME, @session_cookie.to_json)
  end
end
