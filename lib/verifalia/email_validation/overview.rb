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

module Verifalia
  module EmailValidations
    # Overview information for an email validation job.
    class Overview
      # The unique identifier for the validation job.
      attr_reader :id

      # The processing status for the validation job. See +JobStatus+ for a list of the values supported at the time
      # this SDK has been released.
      attr_reader :status

      # The date and time this validation job has been submitted to Verifalia.
      attr_reader :submitted_on

      # The date and time this validation job has been eventually completed.
      attr_reader :completed_on

      # The eventual priority (speed) of the validation job, relative to the parent Verifalia account. In the event of
      # an account with many concurrent validation jobs, this value allows to increase the processing speed of a job
      # with respect to the others.
      #
      # The allowed range of values spans from +0+ - lowest priority, to +255+ - highest priority, where the midway
      # value +127+ means normal priority; if not specified, Verifalia processes all the concurrent validation jobs for
      # an account using the same priority.
      attr_reader :priority

      # An optional user-defined name for the validation job, for your own reference.
      attr_reader :name

      # The unique ID of the Verifalia user who submitted the validation job.
      attr_reader :owner

      # The IP address of the client which submitted the validation job.
      attr_reader :client_ip

      # The date and time the validation job was created.
      attr_reader :created_on

      # A reference to the results quality level this job was validated against.
      attr_reader :quality

      # The maximum data retention period Verifalia observes for this verification job, after which the job will be
      # automatically deleted.
      #
      # A verification job can be deleted anytime prior to its retention period through the +delete()+ method.
      attr_reader :retention

      # A deduplication mode option which affected the way Verifalia eventually marked entries as duplicates upon
      # processing.
      attr_reader :deduplication

      # The number of entries the validation job contains.
      attr_reader :no_of_entries

      # The eventual completion progress for the validation job.
      attr_reader :progress

      def initialize(id, submitted_on, completed_on, priority, name, owner, client_ip, created_on, quality, retention,
                     deduplication, status, no_of_entries, progress)
        @id = id
        @status = status
        @submitted_on = submitted_on
        @completed_on = completed_on
        @priority = priority
        @name = name
        @owner = owner
        @client_ip = client_ip
        @created_on = created_on
        @quality = quality
        @retention = retention
        @deduplication = deduplication
        @no_of_entries = no_of_entries
        @progress = progress
      end
    end
  end
end