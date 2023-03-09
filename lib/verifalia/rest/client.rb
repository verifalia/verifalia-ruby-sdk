# frozen_string_literal: true

require 'faraday'
require 'json'

module Verifalia
  module Rest
    BASE_URLS = %w[https://api-1.verifalia.com/v2.4 https://api-2.verifalia.com/v2.4 https://api-3.verifalia.com/v2.4]
    BASE_CCA_URLS = %w[https://api-cca-1.verifalia.com/v2.4 https://api-cca-2.verifalia.com/v2.4 https://api-cca-3.verifalia.com/v2.4]

    class Client
      # Optional debug logger
      attr_writer :logger

      def initialize(authenticator, user_agent, base_urls)
        @authenticator = authenticator
        @user_agent = user_agent
        @base_urls = base_urls.shuffle()

        @current_base_url_idx = 0
      end

      def invoke(method, resource, options = nil)
        errors = []

        # Performs a maximum of as many attempts as the number of configured base API endpoints, keeping track
        # of the last used endpoint after each call, in order to try to distribute the load evenly across the
        # available endpoints.

        (0...@base_urls.length).each {
          base_url = @base_urls[@current_base_url_idx % @base_urls.length]
          @current_base_url_idx = @current_base_url_idx + 1

          # Build the final URL

          final_url = "#{base_url}/#{resource}"

          @logger.info("Invoking #{method.upcase} #{final_url}") unless @logger.nil?

          # Init the HTTP request

          connection = Faraday.new(
            headers: {'User-Agent' => @user_agent}
          )

          request = connection.build_request(method)
          request.url(final_url)

          # Options

          if !options.nil?
            request.body = options[:body] unless options[:body].nil?
            request.headers = request.headers.merge(options[:headers]) unless options[:headers].nil?
          end

          # Authenticate the underlying client, if needed

          @authenticator.authenticate connection, request

          begin
            # Send the request to the Verifalia servers

            connection.builder.build_response(connection, request).on_complete do |response|
              if (500...599) === response.status
                raise "Server error (HTTP status #{response.status}) while invoking #{final_url}"
              end

              return response
            end
          rescue => error
            @logger.warn("Error while invoking #{method.upcase} #{final_url}. #{error.to_s}") unless @logger.nil?

            errors.append(error)
          end
        }

        # Generate an error out of the potentially multiple invocation errors

        raise "All the base URIs are unreachable:\n#{errors.map { |error| error.to_s }.join("\n")}"
      end
    end
  end
end