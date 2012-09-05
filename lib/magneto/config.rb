module Magneto
  Config = Struct.new(:log, :api_key, :api_user, :wsdl_v1, :wsdl_v2, :magento_soap_version) do
    def self.default
      config = new
      config.log = true
      config.magento_soap_version = 'v1'
      config
    end
  end
end
