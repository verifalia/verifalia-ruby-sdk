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

require_relative 'verifalia/client'

require_relative 'verifalia/credits/balance'
require_relative 'verifalia/credits/client'

require_relative 'verifalia/email_validation/client'
require_relative 'verifalia/email_validation/completion_callback'
require_relative 'verifalia/email_validation/entry'
require_relative 'verifalia/email_validation/entry_classification'
require_relative 'verifalia/email_validation/entry_status'
require_relative 'verifalia/email_validation/exported_entries_format'
require_relative 'verifalia/email_validation/job'
require_relative 'verifalia/email_validation/job_status'
require_relative 'verifalia/email_validation/overview'
require_relative 'verifalia/email_validation/progress'
require_relative 'verifalia/email_validation/request'
require_relative 'verifalia/email_validation/request_entry'
require_relative 'verifalia/email_validation/wait_options'

require_relative 'verifalia/security/username_password_authenticator'
require_relative 'verifalia/security/certificate_authenticator'

module Verifalia
end