# frozen_string_literal: true

module Verifalia
  module EmailValidations
    class Entry
      attr_reader :index, :input_data, :classification, :status, :email_address, :email_address_local_part,
                  :email_address_domain_part, :has_international_mailbox_name, :has_international_domain_name,
                  :is_disposable_email_address, :is_role_account, :is_free_email_address, :syntax_failure_index, :custom,
                  :duplicate_of, :completed_on

      def initialize (index, input_data, classification, status, email_address, email_address_local_part, email_address_domain_part,
                      has_international_mailbox_name, has_international_domain_name, is_disposable_email_address, is_role_account,
                      is_free_email_address, syntax_failure_index, custom, duplicate_of, completed_on)
        @index = index
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
      end
    end
  end
end