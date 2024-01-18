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
    class WaitOptions
      @@default = nil
      @@no_wait = nil

      attr_reader :submission_wait_time, :poll_wait_time, :progress

      def initialize(submission_wait_time, poll_wait_time, progress: nil)
        @submission_wait_time = submission_wait_time
        @poll_wait_time = poll_wait_time
        @progress = progress
      end

      def self.default
        @@default = WaitOptions.new 30 * 1000, 30 * 1000 if @@default.nil?
        @@default
      end

      def self.no_wait
        @@no_wait = WaitOptions.new 0, 0 if @@no_wait.nil?
        @@no_wait
      end

      def wait_for_next_poll(job)
        # Observe the ETA if we have one, otherwise a delay given the following formula:
        # delay = max(0.5, min(30, 2^(log(noOfEntries, 10) - 1)))

        if !job.overview.progress.nil? && !job.overview.progress.estimated_time_remaining.nil?
          # Convert the ETA format (dd.)HH:mm:ss into the number of remaining seconds

          eta_match = /((\d*)\.)?(\d{1,2}):(\d{1,2}):(\d{1,2})/.match(job.overview.progress.estimated_time_remaining)

          days = (eta_match[2] || '0').to_i
          hours = eta_match[3].to_i
          minutes = eta_match[4].to_i
          seconds = eta_match[5].to_i

          delay = days * 24 * 60 * 60 +
                  hours * 60 * 60 +
                  minutes * 60 +
                  seconds
        else
          delay = [0.5, [30, 2**(Math.log10(job.overview.no_of_entries) - 1)].min].max
        end

        sleep(delay)
      end
    end
  end
end
