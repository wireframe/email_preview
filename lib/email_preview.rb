require 'engine' if defined?(Rails)
require 'mail'

module EmailPreview

  class << self
    attr_accessor :emails

    def register(key, &block)
      mail = yield
      self.emails ||= {}
      self.emails[key] = mail
    end
  end
end
