# frozen_string_literal: true

module Verifalia
  module Credits
    # The credits balance for the Verifalia account.
    class Balance
      # The number of credit packs (that is, non-expiring credits) available for the account.
      attr_reader :credit_packs

      # The number of free daily credits of the account, where available.
      attr_reader :free_credits

      # A string representing the amount of time before the daily credits expire, where available, expressed in the form +hh:mm:ss+.
      attr_reader :free_credits_reset_in

      def initialize(credit_packs, free_credits, free_credits_reset_in)
        @credit_packs = credit_packs
        @free_credits = free_credits
        @free_credits_reset_in = free_credits_reset_in
      end

      # Parse a Balance from a JSON string.
      def self.from_json(data)
        Balance.new data['creditPacks'],
                    data['freeCredits'],
                    data['freeCreditsResetIn']
      end
    end
  end
end
