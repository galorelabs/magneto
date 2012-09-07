require 'spec_helper'

def stub_login(success=true)
  if success
    return_value = {:login_response=>{:login_return=>"7ab1f29cd18ac06f309c89ba96517ada"}}
  else
    return_value =  {:fault => {:faultcode => "2", :faultstring => "Access denied."}}
  end 
  Savon::Client.any_instance.should_receive(:request).with(:login, :body => { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }).and_return return_value
end

describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    lambda { Magneto::Session.new() }.should raise_error(Magneto::ConfigError)
  end
end

describe Magneto::Session do

  before do
    Magneto.configure do |config|
      config.api_user = 'foo'
      config.api_key = 'bar'
      config.wsdl_v1 = 'http://www.example.com/wdsl'
    end
  end

  describe '.logged' do
    it 'should return true if log in succeed' do
      stub_login
      session = Magneto::Session.new
      session.should be_a Magneto::Session
      session.login()
      session.logged.should be true
    end

    it 'should return false if log in succeed' do
      stub_login(false)
      session = Magneto::Session.new
      session.should be_a Magneto::Session
      session.login()
      session.logged.should be false
    end
  end
  describe '.token' do
    it 'should return session token' do
      stub_login
      session = Magneto::Session.new
      session.login()
      session.token.should eq '7ab1f29cd18ac06f309c89ba96517ada'
    end
  end

  describe '.client' do
    it 'should be a Savon::Client instance' do
      stub_login
      session = Magneto::Session.new
      session.login()
      session.client.should be_a Savon::Client
    end
  end

  describe '.cart_id' do
    pending 'should hold the cart id' do
      stub_login
      session = Magneto::Session.new
      session.login()
      cart_response = {:call_response => {:call_return => 123}}
      Savon::Client.any_instance.should_receive(:request).with(:login).and_return cart_response
      session.cart_id.should eq 123
    end
  end

end
