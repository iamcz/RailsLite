module RouteHelper
  def link_to(name, url)
    <<-HTML
      <a href="#{url}">#{name}</a>
    HTML
  end

  def button_to
  end
end
