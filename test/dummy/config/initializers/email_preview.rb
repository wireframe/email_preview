# config/initializers/email_preview.rb
# basic example for previewing an email built manually
EmailPreview.register 'simple example email' do
  Mail.new do
    to 'tom@example.com'
    from 'me@foo.com'
    body 'check this out'
  end
end

EmailPreview.register 'multipart email (html + text)' do
  Mail.new do
    from 'bob@example.com'
    to 'jim@foobar.net'
    subject 'This is a test email'

    text_part do
      body 'This is plain text'
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body '<h1>This is HTML</h1>'
    end
  end
end

EmailPreview.register 'multipart email with attachment' do
  Mail.new do
    from 'barb@example.com'
    to 'wowza@foobar.net'
    subject 'download this'
    add_file File.join(File.dirname(__FILE__), '../../fixtures/catz.jpeg')
    text_part do
      body 'this is awesome'
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body '<h1>this is awesome'
    end
  end
end
