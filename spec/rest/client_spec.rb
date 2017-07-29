require 'spec_helper'

describe Verifalia::REST::Client do
  describe 'config at class level' do
    after(:each) do
      Verifalia.instance_variable_set('@configuration', nil)
    end

    it 'should set the account sid and auth token with a config block' do
      Verifalia.configure do |config|
        config.account_sid = 'someSid'
        config.auth_token = 'someToken'
      end

      client = Verifalia::REST::Client.new
      expect(client.account_sid).to eq('someSid')
      expect(client.instance_variable_get('@auth_token')).to eq('someToken')
    end

    it 'should overwrite account sid and auth token if passed to initializer' do
      Verifalia.configure do |config|
        config.account_sid = 'someSid'
        config.auth_token = 'someToken'
      end

      client = Verifalia::REST::Client.new 'otherSid', 'otherToken'
      expect(client.account_sid).to eq('otherSid')
      expect(client.instance_variable_get('@auth_token')).to eq('otherToken')
    end

    it 'should overwrite the account sid if only the sid is given' do
      Verifalia.configure do |config|
        config.account_sid = 'someSid'
        config.auth_token = 'someToken'
      end

      client = Verifalia::REST::Client.new 'otherSid'
      expect(client.account_sid).to eq('otherSid')
      expect(client.instance_variable_get('@auth_token')).to eq('someToken')
    end

    it 'should allow options after setting up auth with config' do
      Verifalia.configure do |config|
        config.account_sid = 'someSid'
        config.auth_token = 'someToken'
      end

      client = Verifalia::REST::Client.new :hosts => ['api.fake.com']

      config = client.instance_variable_get('@config')
      expect(config[:hosts]).to eq(['api.fake.com'])
    end

    it 'should throw an argument error if the sid and token isn\'t set' do
      expect { Verifalia::REST::Client.new }.to raise_error(ArgumentError)
    end

    it 'should throw an argument error if only the account_sid is set' do
      expect { Verifalia::REST::Client.new 'someSid' }.to raise_error(ArgumentError)
    end
  end

  describe '#email_validations' do
    before(:each) do
      Verifalia.configure do |config|
        config.account_sid = 'someSid'
        config.auth_token = 'someToken'
      end
      @client = Verifalia::REST::Client.new
    end

    context 'without parameters' do
      it 'call #new on Verifalia::REST::EmailValidations with correct paramenters' do
        config = @client.instance_variable_get('@config')
        expect(Verifalia::REST::EmailValidations).to receive(:new).with(config, 'someSid', 'someToken')
        @client.email_validations
      end
    end

    context 'with parameter' do
      it 'call #new on Verifalia::REST::EmailValidations with correct paramenters' do
        config = @client.instance_variable_get('@config')
        expect(Verifalia::REST::EmailValidations).to receive(:new).with(config, 'someSid', 'someToken', :unique_id => 'fake')
        @client.email_validations(:unique_id => 'fake')
      end
    end
  end
end
