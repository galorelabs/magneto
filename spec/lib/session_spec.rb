require 'spec_helper'

describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    lambda { Magneto::Session.new() }.should raise_error(Magneto::ConfigError)
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
    pending 'should hold a cart object' do
      session.cart.should be_a Magneto::Cart
    end
  end

end
