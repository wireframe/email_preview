module EmailPreviewHelper
  def render_format(part)
    (part.content_type && part.content_type.include?('text/html')) ? 'html' : 'txt'
  end
end
