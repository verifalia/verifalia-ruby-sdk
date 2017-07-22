[![Circle CI](https://circleci.com/gh/verifalia/verifalia-ruby-sdk.svg?style=shield)](https://circleci.com/gh/verifalia/verifalia-ruby-sdk)
[![Gem Version](https://badge.fury.io/rb/verifalia.svg)](https://badge.fury.io/rb/verifalia)
[![Dependency Status](https://gemnasium.com/verifalia/verifalia-ruby-sdk.svg)](https://gemnasium.com/verifalia/verifalia-ruby-sdk)
[![Code Climate](https://codeclimate.com/github/verifalia/verifalia-ruby-sdk/badges/gpa.svg)](https://codeclimate.com/github/verifalia/verifalia-ruby-sdk)
[![Coverage Status](https://coveralls.io/repos/verifalia/verifalia-ruby-sdk/badge.svg?branch=master&service=github)](https://coveralls.io/github/verifalia/verifalia-ruby-sdk?branch=master)
[![Inline docs](http://inch-ci.org/github/verifalia/verifalia-ruby-sdk.svg?branch=master)](http://inch-ci.org/github/verifalia/verifalia-ruby-sdk)

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
##from scratch
emails = ['alice@example.com', 'bob@example.net']
if (unique_id = @client.email_validations.verify(emails))
  #response is an hash with all the values returned
  response = @client.email_validations.query
  @client.email_validations.destroy
else
  #error is HTTP status code in symbol (:bad_request)
  error = @client.email_validations.error
end

##with additional email data
emails = [
    { inputData: 'alice@example.com', custom: 'custom data' }, #view verifalia API documentation
    { inputData: 'bob@example.net', custom: 'custom data' } #view verifalia API documentation
  ]
if (unique_id = @client.email_validations.verify(emails))
  #response is an hash with all the values returned
  response = @client.email_validations.query
  @client.email_validations.destroy
else
  #error is HTTP status code in symbol (:bad_request)
  error = @client.email_validations.error
end

##with additional options data
emails = [
    { inputData: 'alice@example.com', custom: 'custom data' }, #view verifalia API documentation
    { inputData: 'bob@example.net', custom: 'custom data' } #view verifalia API documentation
  ]
options = { #view verifalia API documentation
  quality: 'high',
  priority: 100,
  deduplication: 'safe'
}

if (unique_id = @client.email_validations.verify(emails, options))
  #response is an hash with all the values returned
  response = @client.email_validations.query
  @client.email_validations.destroy
else
  #error is HTTP status code in symbol (:bad_request)
  error = @client.email_validations.error
end


##with previous unique id
unique_id = "example-example"

#query job  
response = @client.email_validations(unique_id: unique_id).query

#delete job
@client.email_validations(unique_id: unique_id).destroy

# checking job status
if @client.email_validations(unique_id: unique_id).completed?
  response = @client.email_validations(unique_id: unique_id).query
end

```
