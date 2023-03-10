![Verifalia API](https://img.shields.io/badge/Verifalia%20API-v2.4-green)
[![Gem Version](https://badge.fury.io/rb/verifalia.svg)](https://badge.fury.io/rb/verifalia)

# Verifalia - Ruby gem

[Verifalia](https://verifalia.com/) provides a simple HTTPS-based API for **validating email addresses in
real-time** and checking whether they are deliverable or not; this SDK library integrates with Verifalia
and allows to [verify email addresses](https://verifalia.com/) in **Ruby 2.6.0 or higher**.

## Adding Verifalia to your Ruby app

To install using [Bundler](https://bundler.io/) grab the latest version:

```ruby
gem 'verifalia'
```

To manually install `verifalia` via Rubygems simply run `gem install`:

```ruby
gem install verifalia
```

### Authentication ###

First things first: authentication to the Verifalia API is performed by way of either the credentials
of your root Verifalia account or of one of its users (previously known as sub-accounts): if you don't
have a Verifalia account, just [register for a free one](https://verifalia.com/sign-up/free).
For security reasons, it is always advisable to [create and use a dedicated user](https://verifalia.com/client-area#/users/new)
for accessing the API, as doing so will allow to assign only the specific needed permissions to it.

Learn more about authenticating to the Verifalia API at [https://verifalia.com/developers#authentication](https://verifalia.com/developers#authentication)

Once you have your Verifalia credentials at hand, use them while creating a new instance of the
`Verifalia::Client` class, which will be the starting point to every other operation against the
Verifalia API: the supplied credentials will be automatically provided to the API using the HTTP
Basic Auth method.

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

## Validating email addresses ##

Every operation related to verifying / validating email addresses is performed through the
`email_validations` property exposed by the `Verifalia::Client` instance you created above, which
exposes some useful functions: in the next few paragraphs we are looking at the most used ones, so
it is strongly advisable to explore the library and look at the embedded help for other opportunities.

**The library automatically waits for the completion of email verification jobs**: if needed, it is possible
to adjust the wait options and have more control over the entire underlying polling process. Please refer to
the [Wait options](#wait-options) section below for additional details.

### How to validate an email address ###

To validate an email address from a Ruby application you can invoke the `submit()` method: it
accepts one or more email addresses and any eventual verification options you wish to pass to Verifalia,
including the expected results quality, deduplication preferences, processing priority.

In the following example, we verify an email address with this library, using the default options:

```ruby
job = verifalia.email_validations.submit 'batman@gmail.com'

# At this point the address has been validated: let's print its validation
# result to the console.

entry = job.entries[0]
puts "Classification: #{entry.classification} (status: #{entry.status})"

# Classification: Deliverable (status: Success)
```

### How to validate a list of email addresses ###

To verify a list of email addresses - instead of a single address - it is possible to pass an array of strings with the
emails to verify to the `submit()` method; here is an example showing how to verify an array with some
email addresses:

```ruby
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

job = verifalia.email_validations.submit entries, deduplication: 'Relaxed'
```

#### Data retention

Verifalia automatically deletes completed email verification jobs according to the data retention
policy defined at the account level, which can be eventually overriden at the user level: one can
use the [Verifalia clients area](https://verifalia.com/client-area) to configure these settings.

It is also possible to specify a per-job data retention policy which govern the time to live of a submitted
email verification job; to do that, provide the `submit()` method with the keyword argument `retention`
set according to the `dd.hh:MM:ss` format, with the `dd.` part being optional.

Here is how, for instance, one can set a data retention policy of 10 minutes while verifying
an email address:

```ruby
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
job = verifalia.email_validations.submit 'elon.musk@tesla.com', wait_options: wait_options

puts "Status: #{job.overview.status}"
# Status: InProgress
```

#### Progress tracking

For jobs with a large number of email addresses, it could be useful to track progress as they are processed
by the Verifalia email verification engine; to do that, it is possible to create an instance of the
`Verifalia::EmailValidations::WaitOptions` class and provide a lambda which eventually receives progress notifications through the
`progress` property.

Here is how to define a progress notification handler which displays the progress percentage of a submitted
job to the console window:

```ruby
WaitOptions = Verifalia::EmailValidations::WaitOptions

progress = ->(overview) do
  puts "Progress: #{(overview.progress&.percentage || 0) * 100}%..."
end

wait_options = WaitOptions.new 30 * 1000, 30 * 1000, progress: progress

emails = [
  'alice@example.com',
  'bob@example.net',
  'charlie@example.org'
]

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
job_id = 'ec415ecd-0d0b-49c4-a5f0-f35c182e40ea'
job = verifalia.email_validations.get job_id
```

### Don't forget to clean up, when you are done

Verifalia automatically deletes completed jobs after a configurable
data-retention policy (see the related section) but it is strongly advisable that
you delete your completed jobs as soon as possible, for privacy and security reasons.
To do that, you can invoke the `delete()` method passing the job Id you wish to get rid of:

```ruby
verifalia.email_validations.delete job_id
```

Once deleted, a job is gone and there is no way to retrieve its email validation results.

## Managing credits ##

To manage the Verifalia credits for your account you can use the `credits` property exposed
by the `Verifalia::Client` instance created above. Like for the previous topic, in the next
few paragraphs we are looking at the most used operations, so it is strongly advisable to
explore the library and look at the embedded documentation for other opportunities.

### Getting the credits balance ###

One of the most common tasks you may need to perform on your account is retrieving the available
number of free daily credits and credit packs. To do that, you can use the `get_balance()` method,
which returns a `Verifalia::Credits::Balance` object, as shown in the next example:

```ruby
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

### v2.0

Released on TBD, 2023

- Added support for API v2.4
- Added support for new completion callback options
- Added support for specifying a custom wait time while submitting and retrieving email verification jobs
- Breaking change: the default job submission and retrieval behavior is now to wait for the completion
  of jobs (but it is possible to change that through the new `WaitOptions` class)
- Bumped dependencies
- Improved documentation
