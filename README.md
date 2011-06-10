# email_preview

preview emails within your web browser

## Features
* preview HTML or plain text emails from within your web browser
* emails are reloaded with each view so you can tweak/save/refresh for instant verification
* integrates perfectly with existing test fixtures
* convenient form to send any email preview directly to your *real* inbox
* only exposes routes in development mode to prevent leaking into production mode

## Installation

gem 'email_preview'

## Usage

```ruby
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

# Rails ActionMailer Example
# each execution is wrapped with a transaction and 
# rolled back after completed so there are no side-effects
EmailPreview.register 'Rails ActionMailer User activation email' do
  u = User.create :email => 'foo@example.com'
  UserMailer.activation(u)
end
```

browse the list of registered emails and preview them in your browser at:
http://localhost:3000/email_preview

![screenshot](https://img.skitch.com/20110608-p2mck7sahpu3h8uit7akq487w2.jpg)

### (optional) Group related emails using the :category option:

When you have lots of emails in your app, it's useful to group them into
related topics.

```ruby
EmailPreview.register 'User activation', :category => :user do
  u = User.new :email => 'foo@example.com'
  UserMailer.activation(u)
end
EmailPreview.register 'Blog posted', :category => :blog do
  b = Blog.new :title => 'foo'
  BlogMailer.posted(b)
end
```

### (optional) expose to production environment

By default the email_preview feature is only available in development mode.  
To make it available to other environments use:

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
