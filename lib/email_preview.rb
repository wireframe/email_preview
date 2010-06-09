require 'engine' if defined?(Rails)

module EmailPreview

  class << self
    attr_accessor :emails
    attr_accessor :allowed_environments

    def allowed_environments
      @allowed_environments ||= ['development', 'test']
      @allowed_environments
    end
    def register(key, &block)
      self.emails ||= {}
      self.emails[key] = block
    end
    def preview(key)
      puts self.emails[key]
      block = self.emails[key]
      block.call
    end
  end
end
