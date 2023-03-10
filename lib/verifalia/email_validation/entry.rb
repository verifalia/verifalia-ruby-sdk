# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class Entry
      # The input string being validated.
      attr_reader :input_data

      # The classification for the status of this email address.
      #
      # Standard values include +Deliverable+, +Risky+, +Undeliverable+ and +Unknown+.
      attr_reader :classification

      # The validation status for this entry.
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

      def initialize (input_data, classification, status, email_address, email_address_local_part, email_address_domain_part,
                      has_international_mailbox_name, has_international_domain_name, is_disposable_email_address, is_role_account,
                      is_free_email_address, syntax_failure_index, custom, duplicate_of, completed_on, ascii_email_address_domain_part)
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
      end
    end
  end
end