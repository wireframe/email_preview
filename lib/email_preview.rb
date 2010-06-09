require 'engine' if defined?(Rails)
require 'mail'

module EmailPreview

  class << self
    attr_accessor :emails
    attr_accessor :allowed_environments

    def allowed_environments
      @allowed_environments ||= ['development', 'test']
      @allowed_environments
    end
    def register(key, &block)
      mail = yield
      self.emails ||= {}
      self.emails[key] = mail
    end
  end
end
