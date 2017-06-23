# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verifalia/version'

Gem::Specification.new do |spec|
  spec.name          = "verifalia"
  spec.version       = Verifalia::VERSION
  spec.authors       = ["Verifalia"]
  spec.email         = ["support@verifalia.com"]
  spec.summary       = "Verifalia API wrapper (email validation, list cleaning and scrubbing)"
  spec.description   = "A simple library for communicating with the Verifalia RESTful API, validating lists of email addresses and checking whether or not they are deliverable."
  spec.homepage      = "http://verifalia.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ['README.md', 'LICENSE.md']
  spec.rdoc_options = ['--line-numbers', '--inline-source', '--title', '--main', 'README.md']

  spec.add_dependency('builder', '>= 2.1.2')
  spec.add_dependency('rest-client', '> 1.8.0')

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
