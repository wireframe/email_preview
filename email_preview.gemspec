# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "email_preview/version"

Gem::Specification.new do |s|
  s.name        = "email_preview"
  s.version     = EmailPreview::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Sonnek"]
  s.email       = ["ryan@codecrate.com"]
  s.homepage    = ""
  s.summary     = %q{simple tool to preview emails in development environment}
  s.description = %q{render and send sample html and plain text emails to see what they will *really* look like}

  s.rubyforge_project = "email_preview"

  s.add_runtime_dependency(%q<rails>, ['>= 3.0'])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<rake>, ["0.9.2"])
  s.add_development_dependency(%q<sqlite3>, ["1.3.6"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
