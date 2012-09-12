module Magneto
  class Session
    attr_reader :logged, :token, :client
    def initialize(options = {})
      set_config_options(options)
      if @api_user.nil? or @api_key.nil? or @wsdl_v1.nil?
        raise Magneto::ConfigError.new
      end
    end
    
    def set_config_options(options)
      @api_user = options[:api_user] || Magneto.config.api_user
      @api_key = options[:api_key] || Magneto.config.api_key
      @wsdl_v1 = options[:wsdl_v1] || Magneto.config.wsdl_v1
      @wsdl_v2 = options[:wsdl_v2] || Magneto.config.wsdl_v2
    end

    def login
      client = Savon::Client.new @wsdl_v1
      response =  client.request(:login, :body => { :username => @api_user , :api_key => @api_key }).to_hash
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
