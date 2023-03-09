# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class Request
      attr_accessor :entries, :quality, :priority, :deduplication, :name, :retention, :callback

      def initialize(entries, quality: nil, priority: nil, deduplication: nil, name: nil, retention: nil, callback: nil)
        @entries = entries
        @quality = quality
        @priority = priority
        @deduplication = deduplication
        @name = name
        @retention = retention
        @callback = callback
      end
    end
  end
end