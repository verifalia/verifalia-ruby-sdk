# frozen_string_literal: true

module Verifalia
  module Security
    # Allows to authenticate to Verifalia with a client certificate.
    class CertificateAuthenticator
      def initialize(certificate)
        @certificate = certificate
      end

      def authenticate(connection, request)
        connection.ssl = {
          client_cert: @certificate
        }
      end
    end
  end
end