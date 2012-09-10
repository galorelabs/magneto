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
    end
  end
end
