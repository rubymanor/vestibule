class MarkdownInput < SimpleForm::Inputs::TextInput
  def label_text
    (super + ' (' + tmpl.content_tag(:span, "You can use #{markdown_help}.".html_safe, class: 'markdown-note') + ')').html_safe
  end

  def tmpl
    @builder.template
  end

  def markdown_help
    tmpl.link_to 'Markdown', "http://daringfireball.net/projects/markdown/syntax", target: '_blank'
  end
end
