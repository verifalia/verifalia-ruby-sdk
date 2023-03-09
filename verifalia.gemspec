# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verifalia/client'

Gem::Specification.new do |spec|
  spec.name          = "verifalia"
  spec.version       = Verifalia::Client::VERSION
  spec.authors       = ["Verifalia", "Efran Cobisi", "Guido Tersilli"]
  spec.email         = ["support@verifalia.com"]
  spec.summary       = "Verifalia - Ruby SDK and helper library"
  spec.description   = "Verifalia provides a simple API for validating email addresses and checking whether they are deliverable or not. This library allows to easily integrate with Verifalia and verify email addresses in real-time."
  spec.homepage      = "https://verifalia.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ['README.md']
  spec.rdoc_options = ['--line-numbers', '--inline-source', '--title', '--main', 'README.md']

  spec.add_dependency('faraday', '>= 2.7.4')

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
