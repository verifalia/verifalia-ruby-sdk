# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class Progress
      # The overall progress percentage for the job, with a value between 0 and 1.
      attr_reader :percentage
      # A string representing the estimated remaining time for completing the email validation job, expressed in the
      # format +dd.hh:mm:ss+ (where dd: days, hh: hours, mm: minutes, ss: seconds); the initial dd. part is added only
      # for huge lists requiring more than 24 hours to complete.
      attr_reader :estimated_time_remaining

      def initialize (percentage, estimated_time_remaining)
        @percentage = percentage
        @estimated_time_remaining = estimated_time_remaining
      end
    end
  end
end