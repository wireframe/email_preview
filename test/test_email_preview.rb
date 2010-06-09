require 'helper'

class TestEmailPreview < Test::Unit::TestCase
  context "with one registered email" do
    setup do
      EmailPreview.register :hello_world do
        Mail.new do
          from 'mikel@test.lindsaar.net'
          to 'you@test.lindsaar.net'
          subject 'This is a test email'
          body 'i like testing'
        end
      end
    end
    should "have one entry in the configuration" do
      assert_equal 1, EmailPreview.emails.keys.length
    end
  end
end
