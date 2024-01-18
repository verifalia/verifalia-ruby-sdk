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
