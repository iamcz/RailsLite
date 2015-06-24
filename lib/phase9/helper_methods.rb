require 'active_support/inflector'

module HelperMethods
  def path_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

    if PLURAL_PATH_ACTIONS.include?(action)
      "/#{class_name}"
    elsif SINGULAR_PATH_ACTIONS.include?(action) || action == :destroy
      "/#{class_name}/<id>"
    elsif action == :edit
      "/#{class_name}/<id>/edit"
    elsif action == :new
      "/#{class_name}/<id>/new"
    end
  end

  def method_for(action)
    class_name = self.to_s.underscore.chomp("_controller")

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
end
