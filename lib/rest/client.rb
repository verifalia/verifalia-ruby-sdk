require 'rest/email_validations'

module Verifalia
  module REST
    ##
    # The Verifalia::REST::Client class caches authentication parameters and
    # exposes methods to make HTTP requests to Verifalia's REST API. However, you
    # should never really need to call these methods yourself since you can
    # work with the more pleasant wrapper objects like Verifalia::REST::EmailValidations
    #
    # Instantiate a client like so:
    #
    #   @client = Verifalia::REST::Client.new account_sid, auth_token
    #

    # Once you have a client object you can use it to do fun things. Every
    # client object exposes a wrapper for a specific API. For example:
    #
    # ==== @client.email_validations
    #
    class Client

      attr_reader :account_sid, :account_token

      API_VERSION = 'v1.4'

      DEFAULTS = {
        hosts: ['https://api-1.verifalia.com', 'https://api-2.verifalia.com'],
        api_version: 'v1.4'
      }

      ##
      # Instantiate a new HTTP client to talk to Verifalia. The parameters
      # +account_sid+ and +auth_token+ are required, unless you have configured
      # them already using the block configure syntax, and used to generate the
      # HTTP basic auth header in each request. The +args+ parameter is a
      # hash of connection configuration options. the following keys are
      # supported:
      #
      # === <tt>host: 'https://api.verifalia.com'</tt>
      #
      # === <tt>api_version: 'v1.1'</tt>
      #
      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        @config = DEFAULTS.merge! options
        @account_sid = args[0] || Verifalia.account_sid
        @auth_token = args[1] || Verifalia.auth_token

        if @account_sid.nil? || @auth_token.nil?
          raise ArgumentError, 'Account SID and auth token are required'
        end

      end

      ##
      # Instantiate a new HTTP client to talk to Verifalia Email Validation Api.
      # The +args+ parameter is a hash of configuration
      # The following keys are supported:
      #
      # === <tt>unique_id: 'example-example'</tt>
      #
      # The unique if of the Verifalia Email Validation resource
      #
      def email_validations(args = {})
        if (args.empty?)
          @email_validations ||= EmailValidations.new @config, @account_sid, @auth_token
        else
          EmailValidations.new @config, @account_sid, @auth_token, args
        end
      end

    end
  end
end
