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
    # Provides values for the supported validation statuses for a job +entry+.
    module EntryStatus
      # The at sign symbol (@), used to separate the local part from the domain part of the address, has not been found.
      AT_SIGN_NOT_FOUND = 'AtSignNotFound'

      # A connection error occurred while verifying the external mail exchanger rejects nonexistent email addresses.
      CATCH_ALL_CONNECTION_FAILURE = 'CatchAllConnectionFailure'

      # A timeout occurred while verifying fake e-mail address rejection for the mail server.
      CATCH_ALL_VALIDATION_TIMEOUT = 'CatchAllValidationTimeout'

      # Verification failed because of a socket connection error occurred while querying the DNS server.
      DNS_CONNECTION_FAILURE = 'DnsConnectionFailure'

      # A timeout has occurred while querying the DNS server(s) for records about the email address domain.
      DNS_QUERY_TIMEOUT = 'DnsQueryTimeout'

      # The domain of the email address does not exist.
      DOMAIN_DOES_NOT_EXIST = 'DomainDoesNotExist'

      # The domain has a NULL MX (RFC 7505) resource record and can't thus accept email messages.
      DOMAIN_HAS_NULL_MX = 'DomainHasNullMx'

      # The domain of the email address does not have any valid DNS record and couldn't accept messages from another
      # host on the Internet.
      DOMAIN_IS_MISCONFIGURED = 'DomainIsMisconfigured'

      # The email address is provided by a well-known disposable email address provider (DEA).
      DOMAIN_IS_WELL_KNOWN_DEA = 'DomainIsWellKnownDea'

      # The domain part of the email address is not compliant with the IETF standards.
      DOMAIN_PART_COMPLIANCY_FAILURE = 'DomainPartCompliancyFailure'

      # An invalid sequence of two adjacent dots has been found.
      DOUBLE_DOT_SEQUENCE = 'DoubleDotSequence'

      # The item is a duplicate of another email address in the list.
      # To find out the entry this item is a duplicate of, check the +duplicate_of+ property for the +entry+  instance which exposes this status code.
      DUPLICATE = 'Duplicate'

      # The email address has an invalid total length.
      INVALID_ADDRESS_LENGTH = 'InvalidAddressLength'

      # An invalid character has been detected in the provided sequence.
      INVALID_CHARACTER_IN_SEQUENCE = 'InvalidCharacterInSequence'

      # An invalid quoted word with no content has been found.
      INVALID_EMPTY_QUOTED_WORD = 'InvalidEmptyQuotedWord'

      # An invalid folding white space (FWS) sequence has been found.
      INVALID_FOLDING_WHITE_SPACE_SEQUENCE = 'InvalidFoldingWhiteSpaceSequence'

      # The local part of the e-mail address has an invalid length.
      INVALID_LOCAL_PART_LENGTH = 'InvalidLocalPartLength'

      # A new word boundary start has been detected at an invalid position.
      INVALID_WORD_BOUNDARY_START = 'InvalidWordBoundaryStart'

      # The email address is not compliant with the additional syntax rules of the email service provider
      # which should eventually manage it.
      ISP_SPECIFIC_SYNTAX_FAILURE = 'IspSpecificSyntaxFailure'

      # The external mail exchanger responsible for the email address under test rejected the local endpoint, probably
      # because of its own policy rules.
      LOCAL_END_POINT_REJECTED = 'LocalEndPointRejected'

      # The local part of the email address is a well-known role account.
      LOCAL_PART_IS_WELL_KNOWN_ROLE_ACCOUNT = 'LocalPartIsWellKnownRoleAccount'

      # The external mail exchanger rejected the validation request.
      LOCAL_SENDER_ADDRESS_REJECTED = 'LocalSenderAddressRejected'

      # A connection error occurred while validating the mailbox for the e-mail address.
      MAILBOX_CONNECTION_FAILURE = 'MailboxConnectionFailure'

      # The mailbox for the e-mail address does not exist.
      MAILBOX_DOES_NOT_EXIST = 'MailboxDoesNotExist'

      # The requested mailbox is currently over quota.
      MAILBOX_HAS_INSUFFICIENT_STORAGE = 'MailboxHasInsufficientStorage'

      # While both the domain and the mail exchanger for the email address being tested are not from a well-known
      # disposable email address provider (DEA), the mailbox is actually disposable.
      MAILBOX_IS_DEA = 'MailboxIsDea'

      # The requested mailbox is temporarily unavailable; it could be experiencing technical issues or some other
      # transient problem.
      MAILBOX_TEMPORARILY_UNAVAILABLE = 'MailboxTemporarilyUnavailable'

      # A timeout occurred while verifying the existence of the mailbox.
      MAILBOX_VALIDATION_TIMEOUT = 'MailboxValidationTimeout'

      # The mail exchanger responsible for the email address under test hides a honeypot / spam trap.
      MAIL_EXCHANGER_IS_HONEYPOT = 'MailExchangerIsHoneypot'

      # The mail exchanger responsible for the email address is parked / inactive.
      MAIL_EXCHANGER_IS_PARKED = 'MailExchangerIsParked'

      # The mail exchanger being tested is a well-known disposable email address provider (DEA).
      MAIL_EXCHANGER_IS_WELL_KNOWN_DEA = 'MailExchangerIsWellKnownDea'

      # The system assigned a user-defined classification because the input data met the criteria specified in a
      # custom classification override rule.
      OVERRIDE_MATCH = 'OverrideMatch'

      # The external mail exchanger does not support international mailbox names. To support this feature, mail
      # exchangers must comply with RFC 5336 and support and announce both the 8BITMIME and the UTF8SMTP protocol
      # extensions.
      SERVER_DOES_NOT_SUPPORT_INTERNATIONAL_MAILBOXES = 'ServerDoesNotSupportInternationalMailboxes'

      # The external mail exchanger accepts fake, non existent, email addresses; therefore the provided email address
      # MAY be nonexistent too.
      SERVER_IS_CATCH_ALL = 'ServerIsCatchAll'

      # The mail exchanger responsible for the email address under test is temporarily unavailable.
      SERVER_TEMPORARILY_UNAVAILABLE = 'ServerTemporaryUnavailable'

      # A socket connection error occurred while connecting to the mail exchanger which serves the email address domain.
      SMTP_CONNECTION_FAILURE = 'SmtpConnectionFailure'

      # A timeout has occurred while connecting to the mail exchanger which serves the email address domain.
      SMTP_CONNECTION_TIMEOUT = 'SmtpConnectionTimeout'

      # The mail exchanger responsible for the email address under test replied one or more non-standard SMTP replies
      # which caused the SMTP session to be aborted.
      SMTP_DIALOG_ERROR = 'SmtpDialogError'

      # The email address has been successfully validated.
      SUCCESS = 'Success'

      # The domain literal of the email address couldn't accept messages from the Internet.
      UNACCEPTABLE_DOMAIN_LITERAL = 'UnacceptableDomainLiteral'

      # The number of parenthesis used to open comments is not equal to the one used to close them.
      UNBALANCED_COMMENT_PARENTHESIS = 'UnbalancedCommentParenthesis'

      # An unexpected quoted pair sequence has been found within a quoted word.
      UNEXPECTED_QUOTED_PAIR_SEQUENCE = 'UnexpectedQuotedPairSequence'

      # One or more unhandled exceptions have been thrown during the verification process and something went wrong
      # on the Verifalia side.
      UNHANDLED_EXCEPTION = 'UnhandledException'

      # A quoted pair within a quoted word is not closed properly.
      UNMATCHED_QUOTED_PAIR = 'UnmatchedQuotedPair'
    end
  end
end
