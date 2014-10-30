# Verifalia RESTful API - Ruby gem

Verifalia provides a simple HTTPS-based API for validating email addresses and checking whether or not they are deliverable;
this Ruby gem allows to communicate with the Verifalia API, scrubbing lists of email addresses in a couple of lines of code.
To learn more about Verifalia, please visit http://verifalia.com

## Installation

Add this line to your application's Gemfile:

    gem 'verifalia'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verifalia

## Getting Started With REST ##

### Setup Work ###

```ruby
require 'verifalia'

# put your own credentials here (grabbed from your Verifalia client account area)
account_sid = 'YOUR-ACCOUNT-SID'
auth_token = 'YOUR-AUTH-TOKEN'

# set up a client to talk to the Verifalia REST API
@client = Verifalia::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Verifalia.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Verifalia::REST::Client.new

```

### Email Validations ###

```ruby
#from scratch
emails = ['alice@example.com', 'bob@example.net']
if (unique_id = @client.email_validations.verify(emails))
  #response is an hash with all the values returned
  response = @client.email_validations.query
  @client.email_validations.destroy
else
  #error is HTTP status code in symbol (:bad_request)
  error = @client.email_validations.error
end


#with previous unique id
unique_id = "example-example"

respone = @client.email_validations(unique_id: unique_id).query

@client.email_validations(unique_id: unique_id).destroy

```
