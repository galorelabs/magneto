class Magneto::Session
  def initialize()
    if Magneto.config.api_user.nil? or Magneto.config.api_key.nil? or Magneto.config.wsdl_v1.nil?
      raise Magneto::ConfigError.new
    end
  end
end
