require 'spec_helper'


describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    lambda { Magneto::Session.new() }.should raise_error(Magneto::ConfigError)
  end
end

describe Magneto::Session do
  let(:client) do
    Savon::Client.new do
      wsdl.endpoint = "http://example.com"
      wsdl.namespace = "http://users.example.com"
    end
  end

  before do
    Magneto.configure do |config|
      config.api_user = 'buh'
      config.api_key = 'bah'
      config.wsdl_v1 = 'wsdl'
    end

    savon.expects(:login).with(:username => 'buh', :api_key => 'bah')
  end


  it 'should return true if login ' do
    # Savon::Client.any_instance.should_receive(:request).and_return 'foo'
    # Savon::Client.new(Magneto.config.wsdl_v1)
    client.request(:login) do
      soap.body = { :id => 1 }
    end
  end
end
