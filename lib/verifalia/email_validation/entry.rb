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
    # Represents a single validated entry within a job.
    class Entry
      # The input string being validated.
      attr_reader :input_data

      # The classification for the status of this email address. See +EntryClassification+ for a list of the values
      # supported at the time this SDK has been released.
      attr_reader :classification

      # The validation status for this entry. See +EntryStatus+ for a list of the values supported at the time this SDK
      # has been released.
      attr_reader :status

      # Gets the email address, without any eventual comment or folding white space. Returns +nil+ if the input data
      # is not a syntactically invalid e-mail address.
      attr_reader :email_address

      # Gets the local part of the email address, without comments and folding white spaces.
      attr_reader :email_address_local_part

      # Gets the domain part of the email address, without comments and folding white spaces.
      #
      # If the ASCII-only (punycode) version of the domain part is needed, use +@ascii_email_address_domain_part+.
      attr_reader :email_address_domain_part

      # Gets the domain part of the email address, converted to ASCII if needed using the punycode algorithm and with
      # comments and folding white spaces stripped off.
      #
      # If the non-punycode version of the domain part is needed, use +@email_address_domain_part+.
      attr_reader :ascii_email_address_domain_part

      # If +true+, the email address has an international mailbox name.
      attr_reader :has_international_mailbox_name

      # If +true+, the email address has an international domain name.
      attr_reader :has_international_domain_name

      # If +true+, the email address comes from a disposable email address (DEA) provider.
      #
      # See https://verifalia.com/help/email-validations/what-is-a-disposable-email-address-dea for additional information
      # about disposable email addresses.
      attr_reader :is_disposable_email_address

      # If +true+, the local part of the email address is a well-known role account.
      attr_reader :is_role_account

      # If +true+, the email address comes from a free email address provider (e.g. gmail, yahoo, outlook / hotmail, ...).
      attr_reader :is_free_email_address

      # The position of the character in the email address that eventually caused the syntax validation to fail.
      attr_reader :syntax_failure_index

      # The user-defined, optional string which is passed back upon completing the validation.
      attr_reader :custom

      # The zero-based index of the first occurrence of this email address in the parent +Job+, in the event the +status+
      # for this entry is +Duplicate+; duplicated items do not expose any result detail apart from this and the eventual
      # +custom+ values.
      attr_reader :duplicate_of

      # The date this entry has been completed, if available.
      attr_reader :completed_on

      # The potential corrections for the input data, in the event Verifalia identified potential typos during the verification process.
      attr_reader :suggestions

      def initialize (input_data, classification, status, email_address, email_address_local_part, email_address_domain_part,
                      has_international_mailbox_name, has_international_domain_name, is_disposable_email_address, is_role_account,
                      is_free_email_address, syntax_failure_index, custom, duplicate_of, completed_on, ascii_email_address_domain_part,
                      suggestions)
        @input_data = input_data
        @classification = classification
        @status = status
        @email_address = email_address
        @email_address_local_part = email_address_local_part
        @email_address_domain_part = email_address_domain_part
        @has_international_mailbox_name = has_international_mailbox_name
        @has_international_domain_name = has_international_domain_name
        @is_disposable_email_address = is_disposable_email_address
        @is_role_account = is_role_account
        @is_free_email_address = is_free_email_address
        @syntax_failure_index = syntax_failure_index
        @custom = custom
        @duplicate_of = duplicate_of
        @completed_on = completed_on
        @ascii_email_address_domain_part = ascii_email_address_domain_part
        @suggestions = suggestions
      end
    end
  end
end