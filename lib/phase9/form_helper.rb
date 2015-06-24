module FormHelper
  def link_to(name, url)
    # In Rails
    # link_to text, url
    <<-HTML
      <a href="#{url}">#{h(name)}</a>
    HTML
  end

  def button_to(text, controller, action, method, route_params = {})
    # In Rails:
    # button_to text, {controller: :c, action: :a}, method: :m
    <<-HTML
    HTML
  end

  private

  def h(str)
    str.gsub("<","&lt;").gsub(">","&gt;")
  end
end
