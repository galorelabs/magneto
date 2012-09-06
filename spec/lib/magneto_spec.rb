require 'spec_helper'


describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    lambda { Magneto::Session.new() }.should raise_error(Magneto::ConfigError)
  end
end

describe Magneto::Session do

  before do
    Magneto.configure do |config|
      config.api_user = 'buh'
      config.api_key = 'bah'
      config.wsdl_v1 = 'wsdl'
    end
  end

  it 'should return a Session object if log in succeed' do
    success = {:login_response=>{:login_return=>"7ab1f29cd18ac06f309c89ba96517ada"}}
    Savon::Client.any_instance.should_receive(:request).with(:login).and_return success
    client = Magneto::Session.new
    client.should be_a Magneto::Session
  end
end
