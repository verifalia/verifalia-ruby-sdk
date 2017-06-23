require 'rest_client'
module Verifalia
  module REST
    class EmailValidations
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
      # === <tt> emails: ['test@test.com']
      #
      # An array of emails to validate
      #
      def verify(emails)
        raise ArgumentError, 'emails must be not empty' if (emails.nil? || emails.empty?)
        data = emails.map { |email| { inputData: email }}
        content = { entries: data }.to_json
        begin
          r = @resource.post content
          @unique_id = JSON.parse(r)["uniqueID"]
          @response = nil
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
      def query
        raise ArgumentError, 'You must call verify first or supply and uniqueId' unless @unique_id
        unless is_job_completed?
          begin
            r = @resource[@unique_id].get
            @response = JSON.parse(r)
            @error = nil
          rescue => e
            compute_error(e)
            return false
          end
        end
        @response
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
          @unique_id = nil
          true
        rescue => e
          compute_error(e)
          return false
        end
      end

      ##
      # query and check if the Email validation job is processed. In order to use
      # this method you need to supply unique_id during initialization or call verify first.
      def completed?
        query 
        is_job_completed?
      end

      def error
        @error
      end

      private
      
        ## 
        # Check if the Email validation job in progress, implementation is slightly different than 
        # completed? method, this does not query API unlike completed? method  
        def is_job_completed?
          return false if @response.nil?
          query_progress = @response["progress"]
          query_progress["noOfTotalEntries"] == query_progress["noOfCompletedEntries"]
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
          api_url = "#{config[:host]}/#{config[:api_version]}/email-validations"
          opts = {
            user: account_sid, 
            password: account_token, 
            headers: { content_type: :json }
          }
          return RestClient::Resource.new api_url, opts
        end
    end
  end
end
