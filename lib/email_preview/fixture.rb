module EmailPreview
  class Fixture
    DEFAULT_CATEGORY = 'General'
    attr_accessor :category, :description, :callback

    def initialize(description, options = {}, &block)
      self.category = options[:category] || DEFAULT_CATEGORY
      self.description = options[:description] || description.to_s
      self.callback = block
    end
    def preview
      self.callback.call
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
    alias_method_chain :preview, :transaction
  end

end
