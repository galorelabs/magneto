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

  describe '#add_product' do
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

  describe '#set_customer' do
    it 'should call the template object with correct paramenters' do
      stub_cart
      cart.should_receive(:template).with('cart_customer.set', {:firstname => 'Matteo', :lastname => 'Parmi', :email => 'teo@blomming.com'})
      cart.set_customer({:firstname => 'Matteo', :lastname => 'Parmi', :email => 'teo@blomming.com'})
    end
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_customer.set.xml'))
      stub_cart
      cart.template('cart_customer.set', {:firstname => 'Matteo', :lastname => 'Parmi', :email => 'teo@blomming.com'}).should be_equivalent_to(expected_xml)
    end
  end

  describe '#set_customer_addresses' do
    it 'should call the template object with correct paramenters' do
      stub_cart
      cart.should_receive(:template).with('cart_customer.addresses', {:firstname => 'Matteo', :lastname => 'Parmi', :email => 'teo@blomming.com'})
      cart.set_customer_addresses({:firstname => 'Matteo', :lastname => 'Parmi', :email => 'teo@blomming.com'})
    end
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_customer.addresses.xml'))
      stub_cart
      customer = {
        :firstname => 'Matteo',
        :lastname => 'Parmi',
        :company => 'Blomming',
        :street => 'Via teodosio 65',
        :city => 'Milano',
        :region => 'MI',
        :postcode => '20100',
        :country_id => 'IT',
        :telephone => '0123456789',
        :fax => '0123456789'
      }
      addresses = {
        :shipping_address => customer,
        :billing_address => customer
      }
      cart.template('cart_customer.addresses', addresses).should be_equivalent_to(expected_xml)
    end
  end

  describe '#set_shipping_method' do
    it 'should call the template object with correct paramenters' do
      stub_cart
      cart.should_receive(:template).with('cart_shipping.method', 'foo')
      cart.set_shipping_method('foo')
    end
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_shipping.method.xml'))
      stub_cart
      cart.template('cart_shipping.method', 'flatrate_flatrate').should be_equivalent_to(expected_xml)
    end
  end

  describe '#set_payment_method' do
    it 'should call the template object with correct paramenters' do
      stub_cart
      cart.should_receive(:template).with('cart_payment.method', 'foo')
      cart.set_payment_method('foo')
    end
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart_payment.method.xml'))
      stub_cart
      cart.template('cart_payment.method', 'checkmo').should be_equivalent_to(expected_xml)
    end
  end

  describe '#place_order' do
    it 'should call the template object with correct paramenters' do
      stub_cart
      cart.should_receive(:template).with('cart.order')
      cart.place_order
    end
    it 'should generate the correct xml' do
      expected_xml = IO.read(File.join(File.dirname(__FILE__), '../assets', 'cart.order.xml'))
      stub_cart
      cart.template('cart.order').should be_equivalent_to(expected_xml)
    end
  end
end
