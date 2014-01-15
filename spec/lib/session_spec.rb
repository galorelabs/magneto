require 'spec_helper'
require "savon/mock/spec_helper"

describe Magneto::Session do
  include Savon::SpecHelper
    
  before(:each) do
    savon.mock!
  end
  
  after(:each) do
    savon.unmock! 
  end  

  let(:session) do
    Magneto::Session.new
  end
  
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    savon.unmock!
    expect { Magneto::Session.new() }.to raise_error(Magneto::ConfigError)
  end

  it 'should set Magneto.client as a Savon::Client instance' do
      expect(Magneto.client).to_not be_nil
      expect(Magneto.client).to be_a Savon::Client 
  end
  

  describe '#login' do
    it 'should return true if log in succeed' do     
      fixture = File.read("spec/fixture/login.xml")
      savon.expects(:login).with(message: :any).returns(fixture)
      
      session = Magneto::Session.new  
      session.login()
      expect(session.logged).to be_true
    end

    it 'should should raise error if log is unsuccesful' do
      fixture = File.read("spec/fixture/login_fail.xml")
      savon.expects(:login).with(message: :any).returns(fixture)
      
      session = Magneto::Session.new  
      expect{session.login()}.to raise_error(Magneto::LoginError)
    end
  end

  describe '@token' do
    it 'should hold session token' do
      fixture = File.read("spec/fixture/login.xml")
      savon.expects(:login).with(message: :any).returns(fixture)      
      
      session = Magneto::Session.new 
      session.login()
      expect(session.token).to eq '55a5dd43904e0ad8d4aca47644d2b827'
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
