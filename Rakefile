# frozen_string_literal: true

require "bundler/gem_tasks"

task default: %i[spec rubocop]

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r verifalia.rb"
end