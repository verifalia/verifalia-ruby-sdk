# frozen_string_literal: true

require 'net/http'
require_relative 'job'
require_relative 'overview'
require_relative 'entry'
require_relative 'wait_options'
require_relative 'request'
require_relative 'request_entry'
require_relative 'completion_callback'

module Verifalia
  module EmailValidations
    # Allows to verify email addresses and manage email verification jobs using the Verifalia service.
    class Client
      def initialize(rest_client)
        @rest_client = rest_client
      end

      # Submits a new email validation for processing.
      #
      # By default, this method waits for the completion of the email validation job: pass a +WaitOptions+ to request
      # a different waiting behavior.
      def submit(data,
                 quality: nil,
                 priority: nil,
                 deduplication: nil,
                 name: nil,
                 retention: nil,
                 completion_callback: nil,
                 wait_options: nil)
        # Determine how to handle the submission, based on the type of the argument

        if data.nil?
          raise "data can't be nil."
        elsif data.is_a?(String)
          data = Request.new [(RequestEntry.new data)],
                             quality: quality
        elsif data.is_a? Enumerable
          entries = data.map do |entry|
            case entry
            when String
              # data is an Array[String]
              RequestEntry.new entry.to_s
            when RequestEntry
              # data is an Array[RequestEntry]
              entry
            when Hash
              # data is an Array[{ :inputData, :custom }]

              raise 'Input hash must have an :inputData key.' unless entry.key?(:input_data)

              RequestEntry.new entry[:input_data], entry[:custom]
            else
              raise 'Cannot map input data.'
            end
          end

          data = Request.new entries,
                             quality: quality
        elsif data.is_a?(RequestEntry)
          data = Request.new data,
                             quality: quality
        elsif !data.is_a?(Request)
          raise "Unsupported data type #{data.class}"
        end

        # Completion callback

        if completion_callback.is_a?(Hash)
          completion_callback = Verifalia::EmailValidations::CompletionCallback.new(completion_callback['url'],
                                                                                    completion_callback['version'],
                                                                                    completion_callback['skip_server_certificate_validation'])
        end

        # Send the request to the Verifalia API

        wait_options_or_default = wait_options.nil? ? WaitOptions.default : wait_options

        response = @rest_client.invoke 'post',
                                       "email-validations?waitTime=#{wait_options_or_default.submission_wait_time}",
                                       {
                                         body: {
                                           entries: data.entries.map do |entry|
                                             {
                                               inputData: entry.input_data,
                                               custom: entry.custom
                                             }
                                           end,
                                           quality: quality,
                                           priority: priority,
                                           deduplication: deduplication,
                                           name: name,
                                           retention: retention,
                                           callback: ({
                                             url: completion_callback&.url,
                                             version: completion_callback&.version,
                                             skipServerCertificateValidation: completion_callback&.skip_server_certificate_validation
                                           } unless completion_callback.nil?)
                                         }.to_json,
                                         headers: 
                                           {
                                             'Content-Type': 'application/json',
                                             'Accept': 'application/json'
                                           }
                                         
                                       }

        if response.status == 202 || response.status == 200
          job = Job.from_json(JSON.parse(response.body))

          return job if wait_options_or_default == WaitOptions.no_wait || job.overview.status == 'Completed'

          return wait_for_completion(job, wait_options_or_default)
        end

        raise "Unexpected HTTP response: #{response.status} #{response.body}"
      end

      # Returns an email validation job previously submitted for processing.
      #
      # By default, this method waits for the completion of the email validation job: pass a +WaitOptions+ to request
      # a different waiting behavior.
      def get(id, wait_options: nil)
        wait_options_or_default = wait_options.nil? ? WaitOptions.default : wait_options

        response = @rest_client.invoke 'get',
                                       "email-validations/#{id}?waitTime=#{wait_options_or_default.poll_wait_time}"

        return nil if response.status == 404 || response.status == 410

        if response.status == 202 || response.status == 200
          job = Job.from_json(JSON.parse(response.body))

          return job if wait_options_or_default == WaitOptions.no_wait || job.overview.status == 'Completed'

          return wait_for_completion(job, wait_options_or_default)
        end

        raise "Unexpected HTTP response: #{response.status} #{response.body}"
      end

      # Deletes an email validation job previously submitted for processing.
      def delete(id)
        response = @rest_client.invoke 'delete',
                                       "email-validations/#{id}"

        return if response.status == 200 || response.status == 410

        raise "Unexpected HTTP response: #{response.status} #{response.body}"
      end

      private

      def wait_for_completion(job, wait_options)
        loop do
          # Fires a progress, since we are not yet completed

          wait_options.progress&.call(job.overview)

          # Wait for the next polling schedule

          wait_options.wait_for_next_poll(job)

          job = get(job.overview.id, wait_options: wait_options)

          return nil if job.nil?
          return job unless job.overview.status == 'InProgress'
        end
      end
    end
  end
end