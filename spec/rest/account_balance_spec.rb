require 'spec_helper'

describe Verifalia::REST::AccountBalance do
  let(:config) { { hosts: ["https://api.fake.com"], api_version: "v" } }

  describe '#initialize' do

    it 'create RestClient::Resource with correct parameters' do
      api_url = "#{config[:hosts][0]}/#{config[:api_version]}/account-balance"
      opts = {
        user: 'someSid',
        password: 'someToken',
        headers: { content_type: :json, user_agent: "verifalia-rest-client/ruby/#{Verifalia::VERSION}" }
      }

      expect(RestClient::Resource).to receive(:new).with(api_url, opts)
      Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
    end

    it 'should shuffle hosts array' do
      expect(config[:hosts]).to receive(:shuffle).and_return(["https://api.fake.com"])
      Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
    end

    it 'associate RestClient::Resource to @resource' do
      resource = double()
      allow(RestClient::Resource).to receive(:new).and_return(resource)
      email_validations = Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
      expect(email_validations.instance_variable_get('@resource')).to eq(resource)
    end

  end

  context 'initialized' do
    let(:resource) { double().as_null_object }
    let(:response) { double().as_null_object }
    let(:response_json) { double().as_null_object }
    before(:each) do
      @account_balance = Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
      @account_balance.instance_variable_set('@resource', resource)
    end

    describe '#balance' do

      it 'call #get on @resources' do
        expect(resource).to receive(:get).and_return(response)
        expect(JSON).to receive(:parse).with(response).and_return(response_json)
        @account_balance.balance
      end

      it 'return parsed json' do
        parsed = double()
        expect(resource).to receive(:get)
        expect(JSON).to receive(:parse).and_return(parsed)
        result = @account_balance.balance
        expect(result).to eq(parsed)
      end

      context 'request failed' do

        it 'raise exception, call #compute_error and return false' do
          emails = ['first', 'second']
          expect(resource).to receive(:get).and_raise(RestClient::Exception)
          result = @account_balance.balance
          expect(result).to eq(false)
          expect(@account_balance.error).to eq(:internal_server_error)
        end

        it 'raise exception, call #compute_error and return correct error' do
          emails = ['first', 'second']
          exception = RestClient::Exception.new(nil, 402)
          expect(resource).to receive(:get).and_raise(exception)
          result = @account_balance.balance
          expect(result).to eq(false)
          expect(@account_balance.error).to eq(:payment_required)
        end
      end
    end
  end

end
