# frozen_string_literal: true

require_relative 'balance'

module Verifalia
  module Credits
    # Manages credit packs, daily free credits and usage consumption for the Verifalia account.
    class Client
      def initialize(rest_client)
        @rest_client = rest_client
      end

      # Returns the current credits balance for the Verifalia account.
      def get_balance
        response = @rest_client.invoke 'get',
                                       'credits/balance'

        return Balance.from_json(JSON.parse(response.body)) if response.status == 200

        raise "Unexpected HTTP response: #{response.status} #{response.body}"
      end
    end
  end
end
