# frozen_string_literal: true

# Verifalia - Email list cleaning and real-time email verification service
# https://verifalia.com/
# support@verifalia.com
#
# Copyright (c) 2005-2024 Cobisi Research
#
# Cobisi Research
# Via Della Costituzione, 31
# 35010 Vigonza
# Italy - European Union
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'openssl/x509'
require_relative './rest/client'

module Verifalia
  # HTTPS-based REST client for Verifalia.
  class Client
    # The version of the Verifalia SDK for Ruby.
    VERSION = '2.1.0'

    # Allows to verify email addresses and manage email verification jobs using the Verifalia service.
    attr_reader :email_validations

    # Manages credit packs, daily free credits and usage consumption for the Verifalia account.
    attr_reader :credits

    # Initializes a new HTTPS-based REST client for Verifalia with the specified options.
    #
    # While authenticating with your Verifalia main account credentials is possible, it is strongly advised to create
    # one or more users (formerly known as sub-accounts) with just the required permissions, for improved security.
    # To create a new user or manage existing ones, please visit 'https://verifalia.com/client-area#/users'
    #
    # @param [nil] authenticator A custom authenticator the client will use to authenticate against the Verifalia API.
    # @param [nil] username The user-name used to authenticate against the Verifalia API using basic auth.
    # @param [nil] password The password used to authenticate against the Verifalia API using basic auth.
    # @param [nil] ssl_client_cert The X.509 client certificate used to authenticate against the Verifalia API using mutual TLS authentication. Available to premium Verifalia plans only.
    # @param [nil] ssl_client_key The private key used to authenticate against the Verifalia API using mutual TLS authentication. Available to premium Verifalia plans only.
    # @param [nil] base_urls Alternative base URLs to use while connecting against the Verifalia API.
    # @param [nil] logger A logger where to write diagnostics messages, useful while debugging.
    def initialize(authenticator: nil, username: nil, password: nil, ssl_client_cert: nil, ssl_client_key: nil, base_urls: nil, logger: nil)
      @base_urls = base_urls

      # Initialize the authenticator this client will use while connecting to the Verifalia API

      if !authenticator.nil?
        @authenticator = authenticator
      elsif !username.nil?
        @authenticator = Verifalia::Security::UsernamePasswordAuthenticator.new(username, password)
      elsif !ssl_client_cert.nil?
        @authenticator = Verifalia::Security::CertificateAuthenticator.new(ssl_client_cert, ssl_client_key)
        @base_urls ||= Verifalia::Rest::BASE_CCA_URLS
      else
        raise ArgumentError, 'Username is nil and no other authentication method was specified: please visit https://verifalia.com/client-area to set up a new user, if you don\'t have one.'
      end

      @base_urls ||= Verifalia::Rest::BASE_URLS
      @rest_client = Verifalia::Rest::Client.new(@authenticator,
                                                 "verifalia-rest-client/ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}/#{VERSION}",
                                                 @base_urls)

      @rest_client.logger = logger

      # Initialize the underlying resource clients

      @email_validations = Verifalia::EmailValidations::Client.new(@rest_client)
      @credits = Verifalia::Credits::Client.new(@rest_client)
    end
  end
end
