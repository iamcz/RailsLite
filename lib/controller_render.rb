class ControllerBase
  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    rendered_template = ERB.new(template).result(binding)

    render_content(rendered_template, 'text/html')
  end
end
