# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class Overview
      attr_reader :id, :status, :submitted_on, :completed_on, :priority, :name,
                  :owner, :client_ip, :created_on, :quality, :retention, :deduplication,
                  :no_of_entries, :progress

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