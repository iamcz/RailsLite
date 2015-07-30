require 'active_support/inflector'

module RouterHelper
  SINGULAR_PATH_ACTIONS = [:show, :update, :destroy]
  PLURAL_PATH_ACTIONS = [:index, :create]

  def partial_name_for(controller, action)
    class_name = controller.to_s.underscore.chomp('_controller')

    if PLURAL_PATH_ACTIONS.include?(action)
      class_name
    elsif SINGULAR_PATH_ACTIONS.include?(action)
      class_name.singularize
    elsif action == :edit
      "edit_#{class_name.singularize}"
    elsif action == :new
      "new_#{class_name.singularize}"
    end
  end

  def path_for(controller, action)
    class_name = controller.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_ACTIONS.include?(action)
      "/#{class_name}"
    elsif action == :new
      "/#{class_name}/new"
    elsif SINGULAR_PATH_ACTIONS.include?(action) || action == :destroy
      "/#{class_name}/<id>"
    elsif action == :edit
      "/#{class_name}/<id>/edit"
    end
  end

  def path_sub(path, arg)
    if arg.is_a?(Hash)
      raise 'meta hell' unless arg.keys.include?(:id)
      path.gsub!("<id>", arg[:id].to_s)
    elsif arg
      raise 'meta hell' unless arg.respond_to?(:id)
      path.gsub!("<id>", arg.send(:id).to_s)
    else
      raise 'meta hell'
    end

    path
  end
end
