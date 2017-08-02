require 'rest_client'
require 'json'
module Verifalia
  module REST
    class AccountBalance
      ##
      # The Verifalia::REST::AccountBalance class allow you to comminucate
      # with Account balance Api. You don't need to instantiate this class, but
      # use the client for autoconfiguration. # The +args+ parameter is a hash of configuration
      def initialize(config, account_sid, account_token, args = {})
        @resources = build_resources(config, account_sid, account_token)
      end

      ##
      # Query the Account balance
      #
      def balance()
        begin
          response = multiplex_request do |resource|
            resource[@unique_id].get
          end
          @error = nil
          JSON.parse(response)
        rescue => e
          compute_error(e)
          false
        end
      end

      def error
        @error
      end

      private

        def multiplex_request
          @resources.shuffle.each do |resource|
            begin
              response = yield(resource)
              return response
            rescue => e
              if ((e.is_a? RestClient::Exception) && (e.http_code != 500))
                raise e
              end
            end
          end
          raise RestClient::Exception.new(nil, 500)
        end

        def compute_error(e)
          unless e.is_a? RestClient::Exception
            @error = :internal_server_error
          end

          case e.http_code
            when 400
              @error = :bad_request
            when 401
              @error = :unauthorized
            when 402
              @error = :payment_required
            when 403
              @error = :forbidden
            when 404
              @error = :not_found
            when 406
              @error = :not_acceptable
            when 410
              @error = :gone
            when 429
              @error = :too_many_request
            else
              @error = :internal_server_error
            end
        end

        def build_resources(config, account_sid, account_token)
          opts = {
            user: account_sid,
            password: account_token,
            headers: {
              content_type: :json,
              user_agent: "verifalia-rest-client/ruby/#{Verifalia::VERSION}"
            }
          }
          config[:hosts].map do |host|
            api_url = "#{host}/#{config[:api_version]}/account-balance"
            RestClient::Resource.new api_url, opts
          end
        end
    end
  end
end
