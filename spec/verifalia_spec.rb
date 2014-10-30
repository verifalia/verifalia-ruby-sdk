require 'spec_helper'

describe Verifalia do
  after(:each) do
    Verifalia.instance_variable_set('@configuration', nil)
  end

  it 'should set the account sid and auth token with a config block' do
    Verifalia.configure do |config|
      config.account_sid = 'someSid'
      config.auth_token = 'someToken'
    end

    expect(Verifalia.account_sid).to eq('someSid')
    expect(Verifalia.auth_token).to eq('someToken')
  end
end