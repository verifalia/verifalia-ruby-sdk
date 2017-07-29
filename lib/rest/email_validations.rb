require 'rest_client'
require 'json'
module Verifalia
  module REST
    class EmailValidations

      COMPLETITION_MAX_RETRY = 5
      COMPLETITION_INTERVAL = 1
      ##
      # The Verifalia::REST::EmailValidations class allow you to comminucate
      # with Email Validations Api. You don't need to instantiate this class, but
      # use the client for autoconfiguration. # The +args+ parameter is a hash of configuration
      # The following keys are supported:
      #
      # === <tt>unique_id: 'example-example'</tt>
      #
      # The unique if of the Verifalia Email Validation resource
      #
      def initialize(config, account_sid, account_token, args = {})
        @resource = build_resource(config, account_sid, account_token)
        @unique_id = args[:unique_id] if args[:unique_id]
      end

      ##
      # Query the Email Validations Api with:
      #
      # === <tt> inputs: ['test@test.com']
      # === <tt> inputs: data = [{ inputData: 'first@first.it' }, { inputData: 'first@first.it' } ]
      # === <tt> options: { quality: 'high', priority: 100, deduplication: 'safe' } view verifalia API documentation
      #
      # An array of emails to validate
      #
      def verify(inputs, options = {})
        raise ArgumentError, 'inputs must be not empty' if (inputs.nil? || inputs.empty?)
        raise ArgumentError, 'options must be hash' if (!options.is_a?(Hash))
        data = inputs.map do |input|
          if (input.is_a? String)
            { inputData: input }
          elsif (input.is_a? Hash)
            raise ArgumentError, 'if inputs content is a Hash you need to supply :inputData as key' if (!input.has_key?(:inputData))
            input
          else
            raise ArgumentError, 'inputs content must be a String or a Hash'
          end
        end
        content = ({ entries: data }.merge(options)).to_json
        begin
          @response = @resource.post content
          @query_result = JSON.parse(@response)
          @unique_id = @query_result["uniqueID"]
          @error = nil
          @unique_id
        rescue => e
          compute_error(e)
          false
        end
      end

      ##
      # Query the Email Validations Api for specific result. In order to use
      # this method you need to supply unique_id uring initialization or call verify first. If request fail,
      # you can call <tt>error</tt> to receive detailed information
      #
      # === <tt> options: { wait_for_completion: true, completition_max_retry: 5, completition_interval: 1(seconds) }
      def query(options = {})
        raise ArgumentError, 'You must call verify first or supply and uniqueId' unless @unique_id
        opts = {
          wait_for_completion: false,
          completition_max_retry: COMPLETITION_MAX_RETRY,
          completition_interval: COMPLETITION_INTERVAL,
          }
          .merge! options
        if @response == nil || !completed?
          begin
            loop_count = 0
            resource =  @resource[@unique_id]
            loop do
              @response = resource.get
              @query_result = JSON.parse(@response)
              @error = nil
              loop_count += 1
              sleep opts[:completition_interval] if opts[:wait_for_completion]
              break if !opts[:wait_for_completion] || (completed? || loop_count >= opts[:completition_max_retry])
            end
          rescue => e
            compute_error(e)
            return false
          end
        end
        @query_result
      end

      ##
      # Destroy an Email Validations entity. In order to use
      # this method you need to supply unique_id during initialization or call verify first. If request fail,
      # you can call <tt>error</tt> to receive detailed information
      #
      def destroy
        raise ArgumentError, 'You must call verify first or supply and uniqueId' unless @unique_id
        begin
          r = @resource[@unique_id].delete
          @error = nil
          @response = nil
          @query_result = nil
          @unique_id = nil
          true
        rescue => e
          return true if (e.is_a? RestClient::Exception && e.http_code == 410)
          compute_error(e)
          return false
        end
      end

      ##
      # Check if the Email validation entity is completed processed. In order to use
      # this method you need to supply unique_id during initialization or call verify first.
      #
      def completed?
        @response.code == 200
      end

      def error
        @error
      end

      private
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
            when 404
              @error = :not_found
            when 406
              @error = :not_acceptable
            when 410
              @error = :gone
            else
              @error = :internal_server_error
            end
        end

        def build_resource(config, account_sid, account_token)
          host = config[:hosts].shuffle.first
          api_url = "#{host}/#{config[:api_version]}/email-validations"
          opts = {
            user: account_sid,
            password: account_token,
            headers: {
              content_type: :json,
              user_agent: "verifalia-rest-client/ruby/#{Verifalia::VERSION}"
            }
          }
          return RestClient::Resource.new api_url, opts
        end
    end
  end
end
