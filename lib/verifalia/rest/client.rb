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

require 'faraday'
require 'json'

module Verifalia
  module Rest
    BASE_URLS = %w[https://api-1.verifalia.com/v2.5 https://api-2.verifalia.com/v2.5 https://api-3.verifalia.com/v2.5].freeze
    BASE_CCA_URLS = %w[https://api-cca-1.verifalia.com/v2.5 https://api-cca-2.verifalia.com/v2.5 https://api-cca-3.verifalia.com/v2.5].freeze

    class Client
      # Optional debug logger
      attr_writer :logger

      def initialize(authenticator, user_agent, base_urls)
        @authenticator = authenticator
        @user_agent = user_agent
        @base_urls = base_urls.shuffle

        @current_base_url_idx = 0
      end

      def invoke(method, resource, options = nil)
        errors = []

        # Performs a maximum of as many attempts as the number of configured base API endpoints, keeping track
        # of the last used endpoint after each call, in order to try to distribute the load evenly across the
        # available endpoints.

        (0...@base_urls.length).each {
          base_url = @base_urls[@current_base_url_idx % @base_urls.length]
          @current_base_url_idx += 1

          # Build the final URL

          final_url = "#{base_url}/#{resource}"

          @logger&.info("Invoking #{method.upcase} #{final_url}")

          # Init the HTTP request

          connection = Faraday.new(
            headers: { 'User-Agent' => @user_agent }
          )

          request = connection.build_request(method)
          request.url(final_url)

          # Options

          unless options.nil?
            request.body = options[:body] unless options[:body].nil?
            request.headers = request.headers.merge(options[:headers]) unless options[:headers].nil?
          end

          # Authenticate the underlying client, if needed

          @authenticator.authenticate connection, request

          begin
            # Send the request to the Verifalia servers

            connection.builder.build_response(connection, request).on_complete do |response|
              if (500...599).include?(response.status)
                raise "Server error (HTTP status #{response.status}) while invoking #{final_url}"
              end

              return response
            end
          rescue => e
            @logger&.warn("Error while invoking #{method.upcase} #{final_url}. #{e.to_s}")
            errors.append(e)
          end
        }

        # Generate an error out of the potentially multiple invocation errors

        raise "All the base URIs are unreachable:\n#{errors.map { |error| error.to_s }.join("\n")}"
      end
    end
  end
end