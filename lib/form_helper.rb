require 'active_support/inflector'

module FormHelper
  PUBLIC_METHODS = [:get, :post]
  HIDDEN_METHODS = [:put, :patch, :delete]

  class FormError < StandardError
  end

  def link_to(name, url)
    # In Rails
    # link_to text, url
    <<-HTML
      <a href="#{url}">#{h(name)}</a>
    HTML
  end

  def button_to(name = nil, options = nil, html_options = nil)
    # In Rails:
    # button_to text, {controller: :c, action: :a}, method: :m
    
    value_attr = name.is_a?(String) ? " value=\"#{name}\"" : ""
    if name.is_a?(Array)
      action = name.first
      controller = name.last.class.controller
      action_papth = controller.path_for(action)
    end

    if options.is_a?(Hash)
      action = options[:action].to_sym
      controller = ( options[:controller] || self.class ).to_s.constantize
      action_path = Router.path_for(controller, action)
    elsif options.is_a?(String)
      action_path = options
    end
    
    if html_options.is_a?(Hash)
      method = html_options[:method] 
    end
    
    method ||= :post

    raise FormError unless (PUBLIC_METHODS + HIDDEN_METHODS).include?(method)
    form_method = (method == :get) ? "get" : "post"

    <<-HTML
      <form class="button_to" action="#{action_path}" method="#{form_method}">
        #{hidden_method_for(method)}
        <button type="submit"#{value_attr}>
        </button>
      </form>
    HTML
  end

  private

  def hidden_method_for(method)
    if HIDDEN_METHODS.include?(method)
      <<-HTML
        <input type="hidden" name="_method" value="#{method}">
      HTML
    end
  end

  def h(str)
    str.gsub("<","&lt;").gsub(">","&gt;")
  end
end
