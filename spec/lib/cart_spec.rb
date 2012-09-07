require 'spec_helper'

describe Magneto::Cart do
  it 'should create a cart via soap api' do
    cart_response = {:call_response => {:call_return => '1212'}}
    Magneto.client = Savon::Client.new
    Savon::Client.any_instance.should_receive(:request).with(:call, :body => {  :session_id => 'token',  'resourcePath' => 'cart.create'}).
    and_return cart_response
    cart = Magneto::Cart.new('token')
    cart.cart_id.should eq '1212'
  end
end
