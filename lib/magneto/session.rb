class Magneto::Session
  def initialize()
    if Magneto.config.api_user.nil? or Magneto.config.api_key.nil? or Magneto.config.wsdl_v1.nil?
      raise Magneto::ConfigError.new
    end

    client = Savon::Client.new Magneto.config.wsdl_v1
    response =  client.request :login do |soap|
      soap.body = {:login => 'asdasd', :pw => 'asdasd'}
    end.to_hash
  end
end
