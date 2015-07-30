require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'params'
require_relative 'flash'
require_relative 'form_helper'

class ControllerBase
  include FormHelper

  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_response = false
    @params = Params.new(req, route_params)
    # @router = router
    # 
    # define_router_helpers
  end
  
  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise if already_built_response?

    @res.status = 302
    @res['location'] = url
    @already_built_response = true

    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    rendered_template = ERB.new(template).result(binding)

    render_content(rendered_template, 'text/html')
  end

  def render_content(content, content_type)
    raise if already_built_response?

    @res.body = content
    @res.content_type = content_type
    @already_built_response = true

    session.store_session(@res)
    flash.store_flash(@res)
  end

  def invoke_action(name)
    self.send(name)

    render(name) unless already_built_response?
  end

  def session
    @session ||= Session.new(@req)
  end
  
  def flash
    @flash ||= Flash.new(req)
  end

  private

  def define_router_helpers
    @router.helpers.each do |helper|
      # we are defining the helpers on JUST THIS instance of the controller
      self.define_singleton_method(helper) do |arg=nil|
        @router.send(helper, arg)
      end
    end
  end
end
