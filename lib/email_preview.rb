require 'mail'
require 'email_preview/engine' if defined?(Rails)
require 'email_preview/fixture'

module EmailPreview
  class << self
    attr_accessor :registry
    attr_accessor :allowed_environments
    attr_accessor :transactional
    attr_accessor :logger
    attr_accessor :before_preview_hook

    def register(description, options={}, &block)
      fixture = EmailPreview::Fixture.new(description, options, &block)
      self.registry << fixture
    end
    def categories
      self.registry.collect {|f| f.category }.uniq
    end
    def preview(key)
      EmailPreview.before_preview_hook.call
      mail = nil
      ActiveRecord::Base.transaction do
        mail = self[key].preview
        raise ActiveRecord::Rollback, "EmailPreview rollback" if EmailPreview.transactional?
      end
      mail
    end
    def [](key)
      self.registry[key.to_i]
    end
    def transactional?
      !!self.transactional
    end
    def before_preview(&block)
      @before_preview_hook = block
    end
  end
end

# initialize registry
EmailPreview.registry = []

# default to only run in development and test environment
EmailPreview.allowed_environments = %w{ development test }

# default to rollback transactions after previewing email
EmailPreview.transactional = true

EmailPreview.logger = Logger.new(STDOUT)

# default before_preview hook to noop
EmailPreview.before_preview do
end
