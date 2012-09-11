# Magneto

Magneto: connect to your magento installation

## Installation

Add this line to your application's Gemfile:

    gem 'magneto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magneto

## Usage

initializer:

    Magneto.configure do |config|
      config.api_user = 'xxxxx'
      config.api_key = 'xxxxxx'
      config.wsdl_v1 = 'http://xxxxxx.com/index.php/api/soap/?wsdl'
      config.wsdl_v2 = 'http://xxxxxx.com/index.php/api/v2_soap?wsdl=1'
    end


use it:

    session = Magneto::Session.new  
    session.login()
    session.token #return session token
    session.cart  #return cart object
    session.cart.token #alias for session#token
    session.cart.cart_id #return magento cart_id
  
    #add products actually use product_id as hash key, as the magento 1.6 api
    #works only with product_id
    session.cart.add_product([{ 9987 =>1 }, { 9884 => 1} ])

    #customer data
    customer = {
      :firstname => 'Matteo',
      :lastname => 'Parmi',
      :email => 'teo@blomming.com', 
      :company => 'Blomming',
      :street => 'Via teodosio 65',
      :city => 'Milano',
      :region => 'MI',
      :postcode => '20100',
      :country_id => 'IT',
      :telephone => '0123456789',
      :fax => '012345678'
    }
    addresses = {
      :shipping_address => customer,
      :billing_address => customer
    }

    #customer only nedd :firstname, :lastname and :email
    session.cart.set_customer(customer)
    #set customer addresses
    session.cart.set_customer_addresses(addresses)

    session.cart.set_shipping_method('flatrate_flatrate')
    session.cart.set_payment_method('checkmo')
    session.cart.place_order



    #this is an inported spikes that uses magento v2 api. not tested.
    Magneto.product.products_list
    Magneto.product.categories
    Magneto.product.product_details(9987)
    Magneto.product.stock_info([9987,9884])



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes -- and tests -- (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
