# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verifalia/client'

Gem::Specification.new do |spec|
  spec.name          = 'verifalia'
  spec.version       = Verifalia::Client::VERSION
  spec.authors       = ['Verifalia', 'Efran Cobisi', 'Guido Tersilli', 'Rudy Chiappetta', 'Germano Mosconi']
  spec.email         = ['support@verifalia.com']
  spec.summary       = 'Verifalia - Ruby SDK and helper library'
  spec.description   = 'Verifalia provides a simple API for validating email addresses and checking whether they are deliverable or not. This library allows to easily integrate with Verifalia and verify email addresses in real-time.'
  spec.homepage      = 'https://verifalia.com/'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/verifalia/verifalia-ruby-sdk.git'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.extra_rdoc_files = ['README.md']

  spec.add_dependency('faraday', '~> 2.7')

  spec.add_development_dependency 'bundler', '~> 2.4.8'
  spec.add_development_dependency 'rake', '~> 13.0'
end
