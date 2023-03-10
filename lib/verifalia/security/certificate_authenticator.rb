# frozen_string_literal: true

module Verifalia
  module Security
    # Allows to authenticate to Verifalia with a client certificate.
    class CertificateAuthenticator
      def initialize(ssl_client_cert, ssl_client_key)
        ssl_client_cert = OpenSSL::X509::Certificate.new(File.read(ssl_client_cert)) if String === ssl_client_cert
        ssl_client_key = OpenSSL::PKey::RSA.new(File.read(ssl_client_key)) if String === ssl_client_key && !ssl_client_key.nil?

        @ssl_client_cert = ssl_client_cert
        @ssl_client_key = ssl_client_key
      end

      def authenticate(connection, request)
        connection.ssl.client_cert = @ssl_client_cert
        connection.ssl.client_key = @ssl_client_key
      end
    end
  end
end