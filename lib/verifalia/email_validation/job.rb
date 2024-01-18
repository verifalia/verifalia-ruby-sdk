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

require 'ipaddr'

module Verifalia
  module EmailValidations
    # Represents a snapshot of an email validation job, along with its overview and eventually validated entries.
    class Job
      # Overview information for this email validation job.
      attr_reader :overview

      # The eventually validated items for this email validation job.
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
                                (if data['overview'].key?('completedOn')
                                   DateTime.iso8601(data['overview']['completedOn'])
                                 end),
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
                      entry['asciiEmailAddressDomainPart'],
                      (entry['suggestions'] if entry.key?('suggestions')) || []
          end
        end

        Job.new overview, entries
      end
    end
  end
end
