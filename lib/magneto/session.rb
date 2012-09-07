class Magneto::Session
  attr_reader :logged, :token, :client
  def initialize()
    if Magneto.config.api_user.nil? or Magneto.config.api_key.nil? or Magneto.config.wsdl_v1.nil?
      raise Magneto::ConfigError.new
    end
  end

  def login
    @logged = false
    client = Savon::Client.new Magneto.config.wsdl_v1
    response =  client.request :login, :body => { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }
    if response.to_hash.has_key? :login_response
      @client = client
      @logged = true
      @token = response[:login_response][:login_return]
    end
  end
  
  def cart_id
    @cart_id ||= begin
      request = @client.request(:call, :body => {  :session_id => token,  'resourcePath' => 'cart.create' })
      request.to_hash[:call_response][:call_return]
    end
  end
end
