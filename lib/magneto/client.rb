class Magneto::Client
  def initialize()
    client = Savon::Client.new Magneto.config.wsdl_v1
    response =  client.request :login do |soap|
      soap.body = { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }
    end.to_hash
  end
end
