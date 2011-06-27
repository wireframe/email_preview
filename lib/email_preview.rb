require 'mail'
require 'email_preview/engine' if defined?(Rails)
require 'active_support/secure_random'

module EmailPreview
  class << self
    attr_accessor :registry
    attr_accessor :allowed_environments
    attr_accessor :transactional
    attr_accessor :logger
    attr_accessor :before_preview_hook

    def register(description, options={}, &block)
      key = self.registry.keys.length + 1 #ActiveSupport::SecureRandom.hex
      options[:key] = key
      options[:category] ||= 'General'
      options[:description] ||= description
      options[:block] ||= block
      self.registry[key] = options
    end
    def categories
      self.registry.values.collect {|f| f[:category] }.uniq
    end
    def preview(key)
      EmailPreview.before_preview_hook.call
      mail = nil
      ActiveRecord::Base.transaction do
        mail = self.registry[key.to_i][:block].call
        raise ActiveRecord::Rollback, "EmailPreview rollback" if EmailPreview.transactional?
      end
      mail
    end
    def transactional?
      !!self.transactional
    end
    def before_preview(&block)
      @before_preview_hook = block
    end
  end

  class Fixture
    attr_accessor :id, :category, :description, :callback
    def preview
      @mail ||= self.callback.call
    end
    def preview_with_transaction
      return preview_without_transaction unless EmailPreview.transactional?
      mail = nil
      ActiveRecord::Base.transaction do
        mail = preview_without_transaction
        raise ActiveRecord::Rollback, "EmailPreview rollback"
      end
      mail
    end
    # alias_method_chain :preview, :transaction
  end
end

# initialize registry
EmailPreview.registry = {}

# default to only run in development and test environment
EmailPreview.allowed_environments = %w{ development test }

# default to rollback transactions after previewing email
EmailPreview.transactional = true

EmailPreview.logger = Logger.new(STDOUT)

# default before_preview hook to noop
EmailPreview.before_preview do
end
