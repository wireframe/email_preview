require 'mail'
require 'email_preview/engine' if defined?(Rails)

module EmailPreview
  class << self
    attr_accessor :emails
    attr_accessor :allowed_environments
    attr_accessor :transactional

    def register(description, &block)
      self.emails << {:description => description, :block => block }
    end
    def preview(index)
      mail = nil
      ActiveRecord::Base.transaction do
        mail = self.emails[index.to_i][:block].call
        raise ActiveRecord::Rollback, "EmailPreview rollback" if EmailPreview.transactional?
      end
      mail
    end
    def transactional?
      !!self.transactional
    end
  end
end

# initialize to empty array
EmailPreview.emails = []

# default to only run in development and test environment
EmailPreview.allowed_environments = %w{ development test }

# default to rollback transactions after previewing email
EmailPreview.transactional = true
