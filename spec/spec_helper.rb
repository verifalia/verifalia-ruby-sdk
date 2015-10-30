$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler'
Bundler.setup

require 'verifalia'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
else
  require "simplecov"
  SimpleCov.start
end

