require 'spec_helper'

def cart_response; {:call_response => {:call_return => '1212'}}; end

def stub_cart
  Magneto.client.stub(:request).and_return(cart_response)
end

describe Magneto::Cart do

  let(:cart) do
    Magneto::Cart.new('token')
  end

  it 'should create a cart via soap api' do
    Magneto.client = Savon::Client.new
    Savon::Client.any_instance.should_receive(:request).with(:call, :body => {  :session_id => 'token',  'resourcePath' => 'cart.create'}).and_return cart_response
    cart.cart_id.should eq '1212'
  end

  context '#add_product' do
    it 'should raise error if you don t pass an array of product_id => quantity' do
      stub_cart
      lambda {cart.add_product(12345=>2)}.should raise_error(Magneto::CartError)
    end

    it 'should add products to cart' do
      stub_cart
      Magneto.client.should_receive(:request).with(:call).and_return({:call_response=>{:call_return=>true}})
      cart.add_product([{1234=>3}, {12345=>3}])
    end

    it 'should call the right soap call' do
      stub_cart
      soap = mock('soap')
      Magneto.client.should_receive(:request).with(:call).and_yield(soap)
      soap.should_receive('xml=')
      cart.add_product([{9987=>1},{9884=>1}])
    end

    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_product.add.xml'))
      stub_cart
      cart.template('cart_product.add',[{9987=>1},{9984=>1}]).should be_equivalent_to(expected_xml)
    end
  end

  context '#set_customer' do
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_customer.set.xml'))
      stub_cart
      cart.template('cart_customer.set').should be_equivalent_to(expected_xml)
    end
  end

  pending 'set_customer_addresses'

  context '#set_shipping_method' do
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_shipping.method.xml'))
      stub_cart
      cart.template('cart_shipping.method').should be_equivalent_to(expected_xml)
    end
  end

  context '#set_payment_method' do
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_payment.method.xml'))
      stub_cart
      cart.template('cart_payment.method').should be_equivalent_to(expected_xml)
    end
  end

  context '#place_order' do
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart.order.xml'))
      stub_cart
      cart.template('cart.order').should be_equivalent_to(expected_xml)
    end
  end
end
