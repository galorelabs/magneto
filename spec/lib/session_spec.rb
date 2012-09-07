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

  it 'should set Magneto.client as a Savon::Client instance' do
    stub_login
    session = Magneto::Session.new
    session.login()
    Magneto.client.should be_a Savon::Client
  end

  describe '.login' do
    context '.logged'
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

  describe '.cart' do
    pending 'should hold a cart object' do
      session = Magneto::Session.new
      session.cart.should be_a Magneto::Cart
    end
  end

end
