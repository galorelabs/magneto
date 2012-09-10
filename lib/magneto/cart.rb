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
      xml = template('cart_product.add', products)
      Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
    end

    def set_shipping_method
      xml = template('cart_shipping.method')
      Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
    end

    def set_payment_method
      xml = template('cart_payment.method')
      Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
    end

    def place_order
      xml = template('cart.order')
      Magneto.client.request(:call) {|soap| soap.xml = xml}.to_hash
    end

    def template(resource_path, data=nil)
      method_call = resource_path.gsub('.', '_')
      Magneto::XmlTemplate.new(token, cart_id, resource_path).send(method_call, data)
    end
  end
end
