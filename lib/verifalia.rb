require 'builder'
require 'forwardable'

require 'verifalia/version'
require 'verifalia/util/configuration'

require 'rest/client'

module Verifalia
  extend SingleForwardable

  def_delegators :configuration, :account_sid, :auth_token

  ##
  # Pre-configure with account SID and auth token so that you don't need to
  # pass them to various initializers each time.
  def self.configure(&block)
    yield configuration
  end

  ##
  # Returns an existing or instantiates a new configuration object.
  def self.configuration
    @configuration ||= Util::Configuration.new
  end
  private_class_method :configuration
end
