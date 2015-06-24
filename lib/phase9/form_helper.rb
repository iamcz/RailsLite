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

  def path_for(action)
    class_name = self.class.to_s.to_s.underscore.chomp('_controller')
    action_name = action.to_s
    path_method = "#{class_name}_#{action_name}_path".to_sym
    
    self.send(path_method)
  end

  def h(str)
    str.gsub("<","&lt;").gsub(">","&gt;")
  end
end
