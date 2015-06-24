module FormHelper
  def link_to(name, url)
    <<-HTML
      <a href="#{url}">#{h(name)}</a>
    HTML
  end

  def button_to
  end

  private

  def h(str)
    str.gsub("<","&lt;").gsub(">","&gt;")
  end
end
