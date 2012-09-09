module Magneto
  class Session
    attr_reader :logged, :token, :client
    def initialize()
      if Magneto.config.api_user.nil? or Magneto.config.api_key.nil? or Magneto.config.wsdl_v1.nil?
        raise Magneto::ConfigError.new
      end
    end

    def login
      client = Savon::Client.new Magneto.config.wsdl_v1
      response =  client.request(:login, :body => { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }).to_hash
      if response.has_key? :login_response
        Magneto.client = client
        @logged = true
        @token = response[:login_response][:login_return]
      else
        @logged = false
        raise Magneto::LoginError.new(response)
      end
    end

    def cart
      @cart ||= Magneto::Cart.new(token)
    end
  end
end
