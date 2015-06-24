module FormHelper
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
    <<-HTML
      <form class="button_to" action="#{path_for(action, path_params)}" method="#{method}">
        <button type="submit" value="#{text}">
      </form>
    HTML
  end

  private

  def h(str)
    str.gsub("<","&lt;").gsub(">","&gt;")
  end
end
