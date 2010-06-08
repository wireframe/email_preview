require 'email_preview/engine' if defined?(Rails)

module EmailPreview
  emails = {}
  def register(key, &block)
    mail = yield
    emails[key] = mail
  end
end
