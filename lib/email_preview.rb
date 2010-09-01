require 'mail'
require 'engine' if defined?(Rails)

module EmailPreview

  class << self
    attr_accessor :emails
    attr_accessor :allowed_environments

    def allowed_environments
      @allowed_environments ||= ['development', 'test']
      @allowed_environments
    end
    def register(description, &block)
      self.emails ||= []
      self.emails << {:description => description, :block => block }
    end
    def preview(index)
      self.emails[index.to_i][:block].call
    end
  end
end
