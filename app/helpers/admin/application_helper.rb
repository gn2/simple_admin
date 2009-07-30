module Admin::ApplicationHelper
  
  # Set page title
  def page_title(page_title)  
    content_for(:page_title) { page_title }  
  end
  
  #
  # Form stuff
  #
  
  # Select element with tree
  # Entries must respond to title, as this is the attribute displayed in the tree
  def select_for_tree(model, name, entries, current_object, options = {})
    # Getting the id of the current_object
    current = current_object.id
    # Build the option tags
    option_tags = options_for_tree(entries, current, 0)
    # Check to see if we need to include a blank entry at the top
    option_tags.insert(0, 
      content_tag(:option, 
        ((options[:include_blank] == true) ? "" : options[:include_blank]), :value => ""
        
      )
    ) if options[:include_blank]
    
    # Build the select tag
    options = {:id => "#{model}_#{name}", :name => "#{model}[#{name}]"}.merge(options)
    select_name = options[:name]
    options.delete_if {|key,val| key == :name }
    
    select_tag(select_name, option_tags, options)
  end

  def options_for_tree(entries, current, level, disabled=false)
    options = ''
    entries.each do |entry|
      # Disabling part of the tree, so that one cannot set a child of 
      # an element as a parent of this element and create an infinite loop
      attrs = {:value => entry.id}
      disabled = true if (entry.id == current)
      attrs[:selected] = 'selected' unless entry.children.select {|child| child.id == current}.empty?
      attrs[:disabled] = 'disabled' if disabled

      options << content_tag(:option, ("-" * level) + " #{entry.title.titlecase}", attrs)
      options << options_for_tree(entry.children, current, level + 1, disabled) unless entry.children.empty?
    end
    options
  end

  #
  # Generic input field builders
  #
  def textfield_input(name, value='', options={})
    # Default options
    options = {
      :prefix => "",
      :attribute => name,
      :options => {}
    }.merge(options)
    options[:options] = {
      :class => "text_field"
    }.merge(options[:options])
    
    p = content_tag(:span, label_tag("#{options[:prefix]}[#{options[:attribute]}]", name.titlecase), :class => 'label')
    p += content_tag(:span, text_field_tag("#{options[:prefix]}[#{options[:attribute]}]", value, options[:options]), :class => 'input')
    return content_tag(:p, p)
  end
  
  def passwordfield_input(name, value='', options={})
    # Default options
    options = {
      :prefix => "",
      :attribute => name,
      :options => {}
    }.merge(options)
    options[:options] = {
      :class => "password_field"
    }.merge(options[:options])
    
    p = content_tag(:span, label_tag("#{options[:prefix]}[#{options[:attribute]}]", name.titlecase), :class => 'label')
    p += content_tag(:span, password_field_tag("#{options[:prefix]}[#{options[:attribute]}]", value, options[:options]), :class => 'input')
    return content_tag(:p, p)
  end
  
  def checkbox_input(name, value='', checked=false, options={})
    # Default options
    options = {
      :prefix => "",
      :attribute => name,
      :options => {}
    }.merge(options)
    options[:options] = {
      :class => "check_box"
    }.merge(options[:options])
    
    p_content = label_tag("#{options[:prefix]}[#{options[:attribute]}]", name.titlecase)
    p_content += check_box_tag("#{options[:prefix]}[#{options[:attribute]}]", value, checked, options[:options])
    p = content_tag(:span, p_content, :class => 'label')
    return content_tag(:p, p)
  end
  
  def textarea_input(name, value='', options={})
    # Default options
    options = {
      :prefix => "",
      :attribute => name,
      :options => {}
    }.merge(options)
    options[:options] = {
      :class => "text_area resizable"
    }.merge(options[:options])
    
    p = content_tag(:span, label_tag("#{options[:prefix]}[#{options[:attribute]}]", name.titlecase), :class => 'label')
    p += content_tag(:span, text_area_tag("#{options[:prefix]}[#{options[:attribute]}]", value, options[:options]), :class => 'input')
    return content_tag(:p, p)
  end
  #
  # End of generic input field builders
  #
end