require 'spec_helper'

describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    expect { Magneto::Session.new() }.to raise_error(Magneto::ConfigError)
  end

  it 'should can override config variables if set in initilizer' do
    Magneto.configure do |config|
      config.api_user = 'foo'
      config.api_key = 'bar'
      config.wsdl_v1 = 'http://www.example.com/wdsl'
      config.wsdl_v2 = 'http://www.example.com/wdsl_v2'
    end
    options = {
      :api_user => 'baz',
      :api_key => 'bonk',
      :wsdl_v1 => 'http://www.example.com/wdsl1',
      :wsdl_v2 => 'http://www.example.com/wdsl2',
    }
    session = Magneto::Session.new(options)
    session.instance_variable_get('@api_user').should eq options[:api_user]
    session.instance_variable_get('@api_key').should eq options[:api_key]
    session.instance_variable_get('@wsdl_v1').should eq options[:wsdl_v1]
    session.instance_variable_get('@wsdl_v2').should eq options[:wsdl_v2]
  end
end

describe Magneto::Session do
  before do
    config_magneto
  end

  let(:session) do
    Magneto::Session.new
  end

  it 'should set Magneto.client as a Savon::Client instance' do
    stub_login
    session.login()
    Magneto.client.should be_a Savon::Client
  end

  describe '#login' do
    it 'should return true if log in succeed' do
      stub_login
      session.should be_a Magneto::Session
      session.login()
      session.logged.should be true
    end

    it 'should should raise error if log is unsuccesful' do
      stub_login(false)
      lambda { session.login() } .should raise_error(Magneto::LoginError)
    end
  end

  describe '@token' do
    it 'should hold session token' do
      stub_login
      session.login()
      session.token.should eq '7ab1f29cd18ac06f309c89ba96517ada'
    end
  end

  describe '@cart' do
    it 'should hold a cart object' do
      response = double('response')
      response.should_receive(:to_hash).and_return({:call_response=>{:call_return=>"1212"}})
      client = double('Magneto.client')
      client.should_receive(:request).and_return response
      Magneto.stub(:client).and_return(client)
      session.cart.should be_a Magneto::Cart
    end
  end

end
