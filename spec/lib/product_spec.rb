require 'spec_helper'

describe Magneto::Product, '.ensure_session_alive' do

  before do
    stub_login
  end

  let(:product_api) do
    Magneto::Product.new
  end

  #poor man mock
  class Response
    @@count = 1
    def self.get
      if @@count == 1
        @@count = 2
        {:fault=>{:faultcode=>"5", :faultstring=>"Session expired. Try to relogin."}}
      elsif @@count == 2
         @@count = 1
         {:call_response=>{:call_return=>"000000010"}}
      end
    end
  end


  it 'should call login and redo block call if response is not succesfull' do
    product_api.should_receive(:login)
    response = product_api.ensure_session_alive do
      res = Response.get
    end
    response.should == {:call_response=>{:call_return=>"000000010"}}
  end

  it 'should not call login and not redo block call if response is succesfull' do
    product_api.should_not_receive(:login)
    response = product_api.ensure_session_alive do
      res = {:call_response=>{:call_return=>"000000010"}}
    end
    response.should == {:call_response=>{:call_return=>"000000010"}}
  end
end
