# frozen_string_literal: true

module Verifalia
  module Security
    # Allows to authenticate to Verifalia with a username and password pair.
    class UsernamePasswordAuthenticator
      def initialize(username, password = nil)
        if username.nil? || username.strip.length == 0
          raise ArgumentError, 'username is nil or empty: please visit https://verifalia.com/client-area to set up a new user, if you don\'t have one.'
        end

        @username = username
        @password = password || ''
      end

      def authenticate(connection, request)
        header = Faraday::Utils.basic_header_from(@username, @password)
        request.headers[Faraday::Request::Authorization::KEY] = header
      end
    end
  end
end