module Admin::GenericHelper
  include Admin::ApplicationHelper

  def object_name
    current_model_name.underscore
  end
  
  def object_plural_name
    current_model_name.underscore.pluralize
  end

  def get_attribute_name_for_generic(attribute, pretty_name=false)
    case attribute
    when Symbol
      attribute
    when Hash
      attribute[:name]
    else
      nil
    end
  end

  def item_for_generic(object, attribute)
    name = get_attribute_name_for_generic(attribute)
    has_options = (attribute.is_a?(Symbol)) ? false : true

    # If link
    if name && has_options && attribute[:link]
      link_method = attribute[:link][:method] || :get
      link_confirm = attribute[:link][:confirm] || nil
      link_name = object.respond_to?(name) ? object.send(name) : name.to_s
      
      link_to(h(link_name), send(attribute[:link][:path], object), :method => link_method, :confirm => link_confirm)
    # If specific format
    elsif has_options && attribute[:format] && attribute[:format].is_a?(Proc)
      attribute[:format].call(object)
    # If show raw value (without escaping HTML)
    elsif name && has_options && attribute[:raw]
      object.send(name)
    # Default: show escaped value
    else
      h(object.send(name)) if object.respond_to?(name)
    end
  end

  def form_field_for_generic(object, attribute)
    # Parse config
    case attribute
    when Symbol
      name = attribute
      type = object.column_for_attribute(name).type
      value = object.send(name)
    when Hash
      name = attribute[:name]
      type = attribute[:type] || object.column_for_attribute(name).type
      value = object.send(name) unless attribute[:virtual]
      hash_for_boolean = attribute[:values] if type == :boolean
    end

    prefix = current_model_name.downcase

    # Render the right form element
    case type
    when :string: textfield_input(name.to_s, value, :prefix => prefix)
    when :text: textarea_input(name.to_s, value, :prefix => prefix)
    when :password: passwordfield_input(name.to_s, value, :prefix => prefix)
    when :boolean: checkbox_input(name.to_s, 1, value, :prefix => prefix)
    end
  end
end