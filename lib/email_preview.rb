require 'mail'
require 'email_preview/engine' if defined?(Rails)

module EmailPreview
  class << self
    attr_accessor :registry
    attr_accessor :allowed_environments
    attr_accessor :transactional

    def register(description, options={}, &block)
      key = description.hash.abs
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
  end
end

# initialize registry
EmailPreview.registry = {}

# default to only run in development and test environment
EmailPreview.allowed_environments = %w{ development test }

# default to rollback transactions after previewing email
EmailPreview.transactional = true
