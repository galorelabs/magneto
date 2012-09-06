class Magneto::Session
  attr_reader :logged, :session_token
  def initialize()
    if Magneto.config.api_user.nil? or Magneto.config.api_key.nil? or Magneto.config.wsdl_v1.nil?
      raise Magneto::ConfigError.new
    end
  end
  def login
    @logged = false
    client = Savon::Client.new Magneto.config.wsdl_v1
    response =  client.request :login do |soap|
      soap.body = { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }
    end.to_hash
    if response.has_key? :login_response
      @logged = true
      @session_token = response[:login_response][:login_return]
    end
  end
end
