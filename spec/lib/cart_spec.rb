require 'spec_helper'

def cart_response; {:call_response => {:call_return => '1212'}}; end

def stub_cart
  Magneto.client = Savon::Client.new
  Savon::Client.any_instance.should_receive(:request).with(:call, :body => {  :session_id => 'token',  'resourcePath' => 'cart.create'}).and_return cart_response
end

describe Magneto::Cart do

  let(:cart) do
    Magneto::Cart.new('token')
  end

  it 'should create a cart via soap api' do
    stub_cart
    cart.cart_id.should eq '1212'
  end

  context '#add_product' do
    it 'should raise error if you don t pass an array of product_id => quantity' do
      Magneto.client.stub(:request).and_return(cart_response)
      lambda {cart.add_product(12345=>2)}.should raise_error(Magneto::CartError)
    end
  end
  pending 'set_customer'
  pending 'set_customer_addresses'
  pending 'set_shipping_method'
  pending 'set_payment_method'
  pending 'place_order'
end
