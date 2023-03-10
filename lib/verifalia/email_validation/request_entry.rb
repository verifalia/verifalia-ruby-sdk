# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class RequestEntry
      attr_accessor :input_data, :custom

      def initialize(input_data, custom = nil)
        @input_data = input_data
        @custom = custom
      end
    end
  end
end