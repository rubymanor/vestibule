module BlueprintForms
  DEFAULT_SIZE = 18

  def blueprint_form_for(object, *args, &block)
    options = args.extract_options!
    options.merge!(:builder => BlueprintForms::BlueprintFormBuilder)
    options[:blueprint_size] ||= BlueprintForms::DEFAULT_SIZE
    options[:wrapper] = :blueprint
    BlueprintForms.use_blueprint_override_or_augment_html_options_for(nil, options, "span-#{options[:blueprint_size]}")
    simple_form_for(object, *(args << options), &block)
  end

  class BlueprintFormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
      BlueprintForms.use_blueprint_override_or_augment_html_options_for(:label, options, 'span-3')
      BlueprintForms.use_blueprint_override_or_augment_html_options_for(:input, options, "span-#{blueprint_form_size - 8}")
      BlueprintForms.use_blueprint_override_or_augment_html_options_for(:hint, options, 'span-5 last')
      BlueprintForms.use_blueprint_override_or_augment_html_options_for(:error_wrapper, options, "push-3 span-#{blueprint_form_size - 8}")
      super(attribute_name, options, &block)
    end

    def button(type, *args, &block)
      options = args.extract_options!
      BlueprintForms.merge_class(options, nil, "push-3")
      super(type, *(args << options), &block)
    end

    protected
    def blueprint_form_size
      @blueprint_form_size ||= options[:blueprint_size]
    end
  end

  protected
  def self.use_blueprint_override_or_augment_html_options_for(key, options, augmentation)
    override_key =
      if key.nil?
        :blueprint_html
      else
        :"blueprint_#{key}_html"
      end
    augmentation_key =
      if key.nil?
        :html
      else
        :"#{key}_html"
      end
    if options[override_key]
      options[augmentation_key] = options.delete(override_key)
    else
      merge_class(options, augmentation_key, augmentation)
    end
  end

  def self.merge_class(options, key, new_class)
    merge_point =
      if key.nil?
        options
      else
        options[key] ||= {}
        options[key]
      end
    merge_point[:class] = "#{new_class} #{merge_point[:class]}".strip
  end
end

ActionView::Base.send :include, BlueprintForms
