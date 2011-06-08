# email_preview

preview emails within your web browser

## Features
* preview HTML emails from within your web browser
* emails are reloaded with each view so you can tweak/save/refresh for instant verification
* convenient form to send any email preview directly to your *real* inbox
* only exposes routes in development mode to prevent leaking into production mode

## Installation

gem 'email_preview'

## Usage


```ruby
# config/initializers/email_preview.rb
EmailPreview.register 'simple example email' do
  Mail.new do
    to 'tom@example.com'
    from 'me@foo.com'
    body 'check this out'
  end
end

EmailPreview.register 'multipart email (html + text)' do
  Mail.new do
    from 'mikel@test.lindsaar.net'
    to 'you@test.lindsaar.net'
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

EmailPreview.register 'Rails ActionMailer User activation email' do
  u = User.new :email => 'foo@example.com'
  UserMailer.activation(u)
end
```

browse the list of registered emails and preview them in your browser at:
http://localhost:3000/email_preview

by default the email_preview feature is only available in development mode.  to turn on globally use:

```ruby
# config/initializers/email_preview.rb
EmailPreview.allowed_environments << 'production'
```

## Contributing 

* Fork the project
* Fix the issue
* Add unit tests
* Submit pull request on github

See CONTRIBUTORS.txt for list of project contributors

## Copyright

Copyright (c) 2010 Ryan Sonnek. See LICENSE for details.
