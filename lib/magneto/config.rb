module Magneto
  Config = Struct.new(:log, :api_key, :api_user, :wsdl_v1, :wsdl_v2, :magento_soap_version) do
    def self.default
      config = new
      config.log = true
      config.magento_soap_version = 'v1'
      config
    end
    
    def self.mock
      config = new
      config.api_key  = 'api_key'
      config.api_user = 'api_user'
      config.wsdl_v1  = 'http://www.example.com/index.php/api/soap/?wsdl'
      config.wsdl_v2  = 'http://www.example.com/index.php/api/v2_soap?wsdl=1'
      config
    end
    
  end
end
