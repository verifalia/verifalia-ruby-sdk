# frozen_string_literal: true

require 'ipaddr'

module Verifalia
  module EmailValidations
    # Represents a snapshot of an email validation job, along with its overview and eventual validated entries.
    class Job
      # Overview information for this email validation job.
      attr_reader :overview

      # The eventual validated items for this email validation job.
      attr_reader :entries

      def initialize(overview, entries)
        @overview = overview
        @entries = entries
      end

      # Parse a Job from a JSON string.
      def self.from_json(data)
        progress = nil

        # Parse the eventual progress information

        if data['overview'].respond_to?('progress')
          progress = Progress.new data['overview']['progress']['percentage'].to_f,
                                  data['overview']['estimatedTimeRemaining']
        end

        # Parse the job overview

        overview = Overview.new data['overview']['id'],
                                DateTime.iso8601(data['overview']['submittedOn']),
                                (DateTime.iso8601(data['overview']['completedOn']) if data['overview'].key?('completedOn')),
                                data['overview']['priority'],
                                data['overview']['name'],
                                data['overview']['owner'],
                                IPAddr.new(data['overview']['clientIP']),
                                DateTime.iso8601(data['overview']['createdOn']),
                                data['overview']['quality'],
                                data['overview']['retention'],
                                data['overview']['deduplication'],
                                data['overview']['status'],
                                data['overview']['noOfEntries'],
                                progress

        # Parse the eventual entries

        if data.key?('entries')
          entries = data['entries']['data'].map do |entry|
            Entry.new entry['inputData'],
                      entry['classification'],
                      entry['status'],
                      entry['emailAddress'],
                      entry['emailAddressLocalPart'],
                      entry['emailAddressDomainPart'],
                      (entry['hasInternationalMailboxName'] if entry.key?('hasInternationalMailboxName')),
                      (entry['hasInternationalDomainName'] if entry.key?('hasInternationalDomainName')),
                      (entry['isDisposableEmailAddress'] if entry.key?('isDisposableEmailAddress')),
                      (entry['isRoleAccount'] if entry.key?('isRoleAccount')),
                      (entry['isFreeEmailAddress'] if entry.key?('isFreeEmailAddress')),
                      (entry['syntaxFailureIndex'] if entry.key?('syntaxFailureIndex')),
                      entry['custom'],
                      (entry['duplicateOf'] if entry.key?('duplicateOf')),
                      DateTime.iso8601(entry['completedOn']),
                      entry['asciiEmailAddressDomainPart']
          end
        end

        Job.new overview, entries
      end
    end
  end
end