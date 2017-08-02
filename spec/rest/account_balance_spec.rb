require 'spec_helper'

describe Verifalia::REST::AccountBalance do
  let(:config) { { hosts: ["https://api.fake.com", "https://api-2.fake.com"], api_version: "v" } }

  describe '#initialize' do

    it 'create RestClient::Resource with correct parameters' do
      opts = {
        user: 'someSid',
        password: 'someToken',
        headers: { content_type: :json, user_agent: "verifalia-rest-client/ruby/#{Verifalia::VERSION}" }
      }
      config[:hosts].each do |host|
        api_url = "#{host}/#{config[:api_version]}/account-balance"
        expect(RestClient::Resource).to receive(:new).with(api_url, opts)
      end
      Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
    end

    it 'associate RestClient::Resource to @resources' do
      resource = double()
      allow(RestClient::Resource).to receive(:new).and_return(resource)
      account_balance = Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
      expect(account_balance.instance_variable_get('@resources')).to include(resource)
      expect(account_balance.instance_variable_get('@resources').size).to eq(config[:hosts].size)
    end
  end

  context 'initialized' do
    let(:resources) { [ double().as_null_object, double().as_null_object ] }
    let(:response) { double().as_null_object }
    let(:response_json) { double().as_null_object }

    before(:each) do
      @account_balance = Verifalia::REST::AccountBalance.new(config, 'someSid', 'someToken')
      @account_balance.instance_variable_set('@resources', resources)
    end

    describe '#balance' do

      context 'without errors' do
        it 'call #get on @resources' do
          resources.each { |resource| allow(resource).to receive(:get).and_return(response) }
          expect(JSON).to receive(:parse).with(response).and_return(response_json)
          @account_balance.balance
        end

        it 'return parsed json' do
          parsed = double()
          resources.each { |resource| allow(resource).to receive(:get).and_return(response) }
          expect(JSON).to receive(:parse).and_return(parsed)
          result = @account_balance.balance
          expect(result).to eq(parsed)
        end
      end

      context 'request failed' do

        before(:each) do
          resources.each { |resource| allow(resource).to receive(:get).and_raise(RestClient::Exception.new(nil, 402))}
        end

        it 'raise exception, call #compute_error and return false' do
          result = @account_balance.balance
          expect(result).to eq(false)
        end

        it 'raise exception, call #compute_error and return correct error' do
          result = @account_balance.balance
          expect(result).to eq(false)
          expect(@account_balance.error).to eq(:payment_required)
        end
      end

      context 'with one request failed with 500' do
        before(:each) do
          expect(resources).to receive(:shuffle).and_return([resources[0], resources[1]])
          expect(resources[0]).to receive(:get).and_raise(RestClient::Exception.new(nil, 500))
          expect(resources[1]).to receive(:get).and_return(response)
        end

        it 'return parsed json' do
          parsed = double()
          expect(JSON).to receive(:parse).and_return(parsed)
          result = @account_balance.balance
          expect(result).to eq(parsed)
        end
      end
    end
  end

end
