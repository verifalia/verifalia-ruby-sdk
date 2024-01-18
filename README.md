![Verifalia API](https://img.shields.io/badge/Verifalia%20API-v2.5-green)
[![Gem Version](https://badge.fury.io/rb/verifalia.svg)](https://badge.fury.io/rb/verifalia)

# Verifalia API - Ruby gem

This SDK library integrates with Verifalia and allows to [verify email addresses](https://verifalia.com/) in **Ruby 2.6.0 or higher**.

[Verifalia](https://verifalia.com/) is an online service that provides email verification and mailing list cleaning; it helps businesses reduce
their bounce rate, protect their sender reputation, and ensure their email campaigns reach the intended recipients.
Verifalia can [verify email addresses](https://verifalia.com/) in real-time or in bulk, using its API or client area; it also
offers various features and settings to customize the verification process according to the user’s needs.

Verifalia's email verification process consists of several steps, each taking fractions of a second: it checks the **formatting
and syntax** (RFC 1123, RFC 2821, RFC 2822, RFC 3490, RFC 3696, RFC 4291, RFC 5321, RFC 5322, and RFC 5336) of each email address,
the **domain and DNS records**, the **mail exchangers**, and the **mailbox existence**, with support for internationalized domains
and mailboxes. It also detects risky email types, such as **catch-all**, **disposable**, or **spam traps** / **honeypots**.

Verifalia provides detailed and **accurate reports** for each email verification: it categorizes each email address as `Deliverable`,
`Undeliverable`, `Risky`, or `Unknown`, and assigns one of its exclusive set of over 40 [status codes](https://verifalia.com/developers#email-validations-status-codes).
It also explains the undeliverability reason and provides **comprehensive verification details**. The service allows the user to choose the desired
quality level, the waiting timeout, the deduplication preferences, the data retention settings, and the callback preferences
for each verification.

Of course, Verifalia never sends emails to the contacts or shares the user's data with anyone.

To learn more about Verifalia please see [https://verifalia.com](https://verifalia.com/)

## Table of contents

* [Adding Verifalia to your Ruby app](#adding-verifalia-to-your-ruby-app)
  * [Authentication](#authentication)
    * [Authenticating via Basic Auth](#authenticating-via-basic-auth)
    * [Authenticating via X.509 client certificate (TLS mutual authentication)](#authenticating-via-x509-client-certificate-tls-mutual-authentication)
* [Verifying email addresses](#verifying-email-addresses)
  * [How to verify an email address](#how-to-verify-an-email-address)
  * [How to verify a list of email addresses](#how-to-verify-a-list-of-email-addresses)
  * [Processing options](#processing-options)
    * [Quality level](#quality-level)
    * [Deduplication mode](#deduplication-mode)
    * [Data retention](#data-retention)
  * [Wait options](#wait-options)
    * [Avoid waiting](#avoid-waiting)
    * [Progress tracking](#progress-tracking)
  * [Completion callbacks](#completion-callbacks)
  * [Retrieving jobs](#retrieving-jobs)
  * [Exporting email verification results in different output formats](#exporting-email-verification-results-in-different-output-formats)
  * [Don't forget to clean up, when you are done](#dont-forget-to-clean-up-when-you-are-done)
* [Managing credits](#managing-credits)
  * [Getting the credits balance](#getting-the-credits-balance)
* [Changelog / What's new](#changelog--whats-new)
  * [v2.1](#v21)
  * [v2.0](#v20)

## Adding Verifalia to your Ruby app

Easily include Verifalia in your Ruby application using [Bundler](https://bundler.io/); just add the following line to your Gemfile to get the latest version:

```ruby
gem 'verifalia'
```

To manually install `verifalia` via Rubygems simply run `gem install`:

```ruby
gem install verifalia
```

### Authentication

First things first: authentication to the Verifalia API is performed by way of either the credentials
of your root Verifalia account or of one of its users (previously known as sub-accounts): if you don't
have a Verifalia account, just [register for a free one](https://verifalia.com/sign-up/free).
For security reasons, it is always advisable to [create and use a dedicated user](https://verifalia.com/client-area#/users/new)
for accessing the API, as doing so will allow to assign only the specific needed permissions to it.

Learn more about authenticating to the Verifalia API at [https://verifalia.com/developers#authentication](https://verifalia.com/developers#authentication)

#### Authenticating via Basic Auth

The most straightforward method for authenticating against the Verifalia API involves using a username and password pair.
These credentials can be applied during the creation of a new instance of the `Verifalia::Client` class, serving as the
initial step for all interactions with the Verifalia API: the provided username and password will be automatically
transmitted to the API using the HTTP Basic Auth method.

```ruby
require 'verifalia'

# ...

verifalia = Verifalia::Client.new username: 'your-username', password: 'your-password'
```

#### Authenticating via X.509 client certificate (TLS mutual authentication)

In addition to the HTTP Basic Auth method, this SDK also supports using a cryptographic X.509 client
certificate to authenticate against the Verifalia API, through the TLS protocol. This method, also
called mutual TLS authentication (mTLS) or two-way authentication, offers the highest degree of
security, as only a cryptographically-derived key (and not the actual credentials) is sent over
the wire on each request.

```ruby
# my-cert.pem contains both the private and public (certificate) key, but
# you may specify different files if needed. 

verifalia = Verifalia::Client.new ssl_client_cert: './my-cert.pem',
                                  ssl_client_key: './my-cert.pem'
```

See [how to create a self-signed X.509 client certificate for TLS mutual authentication](https://verifalia.com/help/sub-accounts/how-to-create-self-signed-client-certificate-for-tls-mutual-authentication)
on the Verifalia website, for more information on creating your own certificates for the Verifalia API.

## Verifying email addresses

Every operation related to verifying / validating email addresses is performed through the
`email_validations` attribute exposed by the `Verifalia::Client` instance you created above, which
exposes some useful methods: in the next few paragraphs we are looking at the most used ones, so
it is strongly advisable to explore the library and look at the embedded help for other opportunities.

**The library automatically waits for the completion of email verification jobs**: if needed, it is possible
to adjust the wait options and have more control over the entire underlying polling process. Please refer to
the [Wait options](#wait-options) section below for additional details.

### How to verify an email address

To validate an email address from a Ruby application you can invoke the `submit()` method: it
accepts one or more email addresses and any eventual verification options you wish to pass to Verifalia,
including the expected results quality, deduplication preferences, processing priority.

In the following example, we check an email address with this library, using the default options:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit 'batman@gmail.com'

# At this point the address has been validated: let's print its validation
# result to the console.

entry = job.entries[0]
puts "Classification: #{entry.classification} (status: #{entry.status})"

# Classification: Deliverable (status: Success)
```

As you may expect, each entry may include various additional details about the verified email address:

| Attribute                         | Description                                                                                                                                                                                                                                         |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ascii_email_address_domain_part` | Gets the domain part of the email address, converted to ASCII if needed and with comments and folding white spaces stripped off.                                                                                                                    |
| `classification`                  | A string with the classification for this entry; see `Verifalia::EmailValidations::EntryClassification` for a list of the values supported at the time this SDK has been released.                                                                  |
| `completed_on`                    | The date this entry has been completed, if available.                                                                                                                                                                                               |
| `custom`                          | A custom, optional string which is passed back upon completing the validation. To pass back and forth a custom value, use the `custom` attribute of `Verifalia::EmailValidations::RequestEntry`.                                                    |
| `duplicate_of`                    | The zero-based index of the first occurrence of this email address in the parent `Job`, in the event the `status` for this entry is `Duplicate`; duplicated items do not expose any result detail apart from this and the eventual `custom` values. |
| `index`                           | The index of this entry within its `Job` container; this property is mostly useful in the event the API returns a filtered view of the items.                                                                                                       |
| `input_data`                      | The input string being validated.                                                                                                                                                                                                                   |
| `email_address`                   | Gets the email address, without any eventual comment or folding white space. Returns null if the input data is not a syntactically invalid e-mail address.                                                                                          |
| `email_address_domain_part`       | Gets the domain part of the email address, without comments and folding white spaces.                                                                                                                                                               |
| `email_address_local_part`        | Gets the local part of the email address, without comments and folding white spaces.                                                                                                                                                                |
| `has_international_domain_name`   | If true, the email address has an international domain name.                                                                                                                                                                                        |
| `has_international_mailbox_name`  | If true, the email address has an international mailbox name.                                                                                                                                                                                       |
| `is_disposable_email_address`     | If true, the email address comes from a disposable email address (DEA) provider. <a href="https://verifalia.com/help/email-validations/what-is-a-disposable-email-address-dea">What is a disposable email address?</a>                              |
| `is_free_email_address`           | If true, the email address comes from a free email address provider (e.g. gmail, yahoo, outlook / hotmail, ...).                                                                                                                                    |
| `is_role_account`                 | If true, the local part of the email address is a well-known role account.                                                                                                                                                                          |
| `status`                          | The status for this entry; see `Verifalia::EmailValidations::EntryStatus` for a list of the values supported at the time this SDK has been released.                                                                                                |
| `suggestions`                     | The potential corrections for the input data, in the event Verifalia identified potential typos during the verification process.                                                                                                                    |
| `syntax_failure_index`            | The position of the character in the email address that eventually caused the syntax validation to fail.                                                                                                                                            |

Here is another example, showing some of the additional result details provided by Verifalia:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit 'bat[man@gmal.com'

entry = job.entries[0]
puts "Classification: #{entry.classification}"
puts "Status: #{entry.status}"
puts "Syntax failure index: #{entry.syntax_failure_index}"

puts "Suggestions:"

entry.suggestions.each do |suggestion|
  puts "- #{suggestion}"
end

# Classification: Undeliverable
# Status: InvalidCharacterInSequence
# Syntax failure index: 3
# Suggestions:
# - batman@gmail.com
```

### How to verify a list of email addresses

To check a list of email addresses - instead of a single address - it is possible to pass an array of strings with the
emails to verify to the `submit()` method; here is an example showing how to validate an array with some
email addresses:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit ['batman@gmail.com', 'samantha42@yahoo.it']

job.entries.each do |entry|
  puts "#{entry.input_data} => #{entry.classification} (#{entry.status})"
end

# batman@gmail.com => Deliverable (Success)
# samantha42@yahoo.it => Deliverable (Success)
```

### Processing options

While submitting one or more email addresses for verification, it is possible to specify several
options which affect the behavior of the Verifalia processing engine as well as the verification flow
from the API consumer standpoint.

#### Quality level

Verifalia offers three distinct quality levels - namely, _Standard_, _High_ and _Extreme_  - which rule out how the email verification engine should
deal with temporary undeliverability issues, with slower mail exchangers and other potentially transient
problems which can affect the quality of the verification results. The `submit()` method accepts a `quality` keyword
argument which allows
to specify the desired quality level; here is an example showing how to verify an email address using
the _High_ quality level:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit 'batman@gmail.com', quality: 'High'
```

#### Deduplication mode

While accepting multiple email addresses at once, the `submit()` method allows to specify how to
deal with duplicated entries pertaining to the same input set; Verifalia supports a _Safe_ deduplication
mode, which strongly adheres to the old IETF standards, and a _Relaxed_ mode which is more in line with
what can be found in the majority of today's mail exchangers configurations.

In the next example, we show how to import and verify a list of email addresses and mark duplicated
entries using the _Relaxed_ deduplication mode:

```ruby
emails = [
  'batman@gmail.com',
  'steve.vai@best.music',
  'samantha42@yahoo.it'
]

# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit entries, deduplication: 'Relaxed'
```

#### Data retention

Verifalia automatically deletes completed email verification jobs according to the data retention
policy defined at the account level, which can be eventually overridden at the user level: one can
use the [Verifalia clients area](https://verifalia.com/client-area) to configure these settings.

It is also possible to specify a per-job data retention policy which govern the time to live of a submitted
email verification job; to do that, provide the `submit()` method with the keyword argument `retention`
set according to the `dd.hh:MM:ss` format, with the `dd.` part being optional.

Here is how, for instance, one can set a data retention policy of 10 minutes while verifying
an email address:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit 'batman@gmail.com', retention: '0:10:0'
```

### Wait options

By default, the `submit()` method submits an email verification job to Verifalia and waits
for its completion; the entire process may require some time to complete depending on the plan of the
Verifalia account, the number of email addresses the submission contains, the specified quality level
and other network factors including the latency of the mail exchangers under test.

In waiting for the completion of a given email verification job, the library automatically polls the
underlying Verifalia API until the results are ready; by default, it tries to take advantage of the long
polling mode introduced with the Verifalia API v2.4, which allows to minimize the number of requests
and get the verification results faster.

#### Avoid waiting

In certain scenarios (in a microservice architecture, for example), however, it may preferable to avoid
waiting for a job completion and ask the Verifalia API, instead, to just queue it: in that case, the library
would just return the job overview (and not its verification results) and it will be necessary to retrieve
the verification results using the `get()` method.

To do that, it is possible to specify the `Verifalia::EmailValidations::WaitOptions.no_wait` as the value
for the `wait_options` keyword argument of the `submit()` method, as shown in the next example:

```ruby
wait_options = Verifalia::EmailValidations::WaitOptions.no_wait

# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit 'elon.musk@tesla.com', wait_options: wait_options

puts "Status: #{job.overview.status}"
# Status: InProgress
```

#### Progress tracking

For jobs with a large number of email addresses, it could be useful to track progress as they are processed
by the Verifalia email verification engine; to do that, it is possible to create an instance of the
`Verifalia::EmailValidations::WaitOptions` class and provide a lambda which eventually receives progress notifications through the
`progress` attribute.

Here is how to define a progress notification handler which displays the progress percentage of a submitted
job to the console window:

```ruby
progress = ->(overview) do
  puts "Progress: #{(overview.progress&.percentage || 0) * 100}%..."
end

wait_options = Verifalia::EmailValidations::WaitOptions.new 30 * 1000, 30 * 1000,
                                                            progress: progress

emails = [
  'alice@example.com',
  'bob@example.net',
  'charlie@example.org'
]

# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.submit emails, wait_options: wait_options
```

### Completion callbacks

Along with each email validation job, it is possible to specify an URL which
Verifalia will invoke (POST) once the job completes: this URL must use the HTTPS or HTTP
scheme and be publicly accessible over the Internet.
To learn more about completion callbacks, please see https://verifalia.com/developers#email-validations-completion-callback

To specify a completion callback URL, specify the `completion_callback` keyword argument while
invoking the `submit()` method, as shown in the example below:

```ruby
# verifalia = Verifalia::Client.new ...
verifalia.email_validations.submit 'batman@gmail.com',
                                   completion_callback: {
                                     'url' => 'https://your-website-here/foo/bar'
                                   }
```

Note that completion callbacks are invoked asynchronously and it could take up to
several seconds for your callback URL to get invoked.

### Retrieving jobs

It is possible to retrieve a job through the `get()` method, which
returns, respectively, a `Verifalia::EmailValidations::Job` instance for the desired
email verification job. While doing that, the library automatically waits for the completion of
the job, and it is possible to adjust this behavior by passing to the aforementioned method
a `wait_options` keyword argument, in the exactly same fashion as described for the `submit()` method;
please see the [Wait options](#wait-options) section for additional details.

Here is an example showing how to retrieve a job, given its identifier:

```ruby
# verifalia = Verifalia::Client.new ...
job = verifalia.email_validations.get 'ec415ecd-0d0b-49c4-a5f0-f35c182e40ea'
```

### Exporting email verification results in different output formats

This library also allows to export the entries of a completed email validation
job in different output formats through the `export()` method, with the goal of
generating a human-readable representation of the verification results.

> **WARNING**: While the output schema (columns / labels / data format) is fairly
> complete, you should always consider it as subject to change: use the `get()`
> method instead if you need to rely on a stable output schema.

Here is an example showing how to export a given email verification job as an
Excel (.xslx) file:

```ruby
# verifalia = Verifalia::Client.new ...
data = verifalia.email_validations.export 'ec415ecd-0d0b-49c4-a5f0-f35c182e40ea',
                                          Verifalia::EmailValidations::ExportedEntriesFormat::EXCEL_XLSX

File.open('./export.xlsx', 'wb') do |fp|
  fp.write(data)
end
```

### Don't forget to clean up, when you are done

Verifalia automatically deletes completed jobs after a configurable
data-retention policy (see the related section) but it is strongly advisable that
you delete your completed jobs as soon as possible, for privacy and security reasons.
To do that, you can invoke the `delete()` method passing the job Id you wish to get rid of:

```ruby
# verifalia = Verifalia::Client.new ...
verifalia.email_validations.delete 'ec415ecd-0d0b-49c4-a5f0-f35c182e40ea'
```

Once deleted, a job is gone and there is no way to retrieve its email validation results.

## Managing credits

To manage the Verifalia credits for your account you can use the `credits` attribute exposed
by the `Verifalia::Client` instance created above. Like for the previous topic, in the next
few paragraphs we are looking at the most used operations, so it is strongly advisable to
explore the library and look at the embedded documentation for other opportunities.

### Getting the credits balance

One of the most common tasks you may need to perform on your account is retrieving the available
number of free daily credits and credit packs. To do that, you can use the `get_balance()` method,
which returns a `Verifalia::Credits::Balance` object, as shown in the next example:

```ruby
# verifalia = Verifalia::Client.new ...
balance = verifalia.credits.get_balance

puts "Credit packs: #{balance.credit_packs}"
puts "Free daily credits: #{balance.free_credits} (will reset in #{balance.free_credits_reset_in})"

# Credit packs: 956.332
# Free daily credits: 128.66 (will reset in 09:08:23)
```

To add credit packs to your Verifalia account visit [https://verifalia.com/client-area#/credits/add](https://verifalia.com/client-area#/credits/add).

## Changelog / What's new

This section lists the changelog for the current major version of the library: for older versions,
please see the [project releases](https://github.com/verifalia/verifalia-ruby-sdk/releases).

### v2.1

Released on January 18<sup>th</sup>, 2024

- Added support for API v2.5
- Added support for [classification overrides](https://verifalia.com/help/email-validations/what-are-classification-overrides)
- Added support for AI-powered suggestions
- Added `EntryClassification`, `EntryStatus`, `ExportedEntriesFormat` and `JobStatus` module constants
- Improved documentation

### v2.0

Released on March 12<sup>th</sup>, 2023

- Added support for API v2.4
- Added support for new completion callback options
- Added support for specifying a custom wait time while submitting and retrieving email verification jobs
- Added support for exporting completed email verification jobs in different output formats (CSV, Excel, Excel 97-2003)
- Breaking change: the default job submission and retrieval behavior is now to wait for the completion
  of jobs (but it is possible to change that through the new `WaitOptions` class)
- Bumped dependencies
- Improved documentation
