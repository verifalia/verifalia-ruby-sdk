# frozen_string_literal: true

require 'openssl/x509'
require_relative './rest/client'

module Verifalia
  class Client
    # The version of the Verifalia SDK for Ruby.
    VERSION = "2.0.0-beta"

    # Allows to verify email addresses and manage email verification jobs using the Verifalia service.
    attr_reader :email_validations

    # Initializes a new HTTPS-based REST client for Verifalia with the specified options.
    def initialize(authenticator: nil, username: nil, password: nil, certificate_pem: nil, base_urls: nil, logger: nil)
      @base_urls = base_urls

      if !authenticator.nil?
        @authenticator = authenticator
      elsif !username.nil? then
        @authenticator = Verifalia::Security::UsernamePasswordAuthenticator.new(username, password)
      elsif !certificate_pem.nil? then
        @authenticator = Verifalia::Security::CertificateAuthenticator.new(certificate_pem)
        @base_urls ||= Verifalia::Rest::BASE_CCA_URLS
      else
        raise ArgumentError, 'Username is null and no other authentication method was specified: please visit https://verifalia.com/client-area to set up a new user, if you don\'t have one.'
      end

      @base_urls ||= Verifalia::Rest::BASE_URLS
      @rest_client = Verifalia::Rest::Client.new(@authenticator,
                                                 "verifalia-rest-client/ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}",
                                                 @base_urls)

      @rest_client.logger = logger

      @email_validations = Verifalia::EmailValidations::Client.new(@rest_client)
    end
  end
end