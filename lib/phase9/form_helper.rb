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

  def button_to(text, action, method = :get, path_params = {})
    # In Rails:
    # button_to text, {controller: :c, action: :a}, method: :m
    raise FormError unless (PUBLIC_METHODS + HIDDEN_METHODS).include?(method)
    
    form_method = ( method == :get ) ? :get : :post

    <<-HTML
      <form class="button_to" action="#{path_for(action, path_params)}" method="#{form_method}">
        #{hidden_method_for(method)}
        <button type="submit" value="#{text}">
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
