module Magneto
  class Cart

    attr_reader :token, :cart_id
    def initialize(token)
      @token = token
      response = Magneto.client.request(:call, :body => {  :session_id => token,  'resourcePath' => 'cart.create' })
      @cart_id = response.to_hash[:call_response][:call_return]
    end

    def add_product(products)
      raise Magneto::CartError.new('must need an array of hash, eg: [{ 9987 =>1 }, { 9884 => 1} ]') unless products.is_a? Array
      xml = template('cart_product.add', parse_products(products))
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def set_shipping_method(method)
      xml = template('cart_shipping.method', method)
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def set_payment_method(method)
      xml = template('cart_payment.method', method)
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def place_order
      xml = template('cart.order')
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def set_customer(user)
      xml = template('cart_customer.set',user)
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def set_customer_addresses(user)
      xml = template('cart_customer.addresses',user)
      response = Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
      check_response_for_errors(response)
    end

    def template(resource_path, data=nil)
      method_call = resource_path.gsub('.', '_')
      Magneto::XmlTemplate.new(token, cart_id, resource_path).send(method_call, data)
    end

    private

    # currently in magento 1.6 soap v1 api seems it's impossible to put in the cart
    # a product with quantity more than 1.
    # I've found that putting in the cart the same product many times as quantity does the trick
    def parse_products(products)
      parsed_product = []
      products.map do |product|
        product.values.first.times do
          parsed_product << { product.keys.first => 1 }
        end
      end
      parsed_product
    end

    def check_response_for_errors(response)
      raise Magneto::SoapError.new(response) if response.has_key? :fault
      response
    end
  end
end
