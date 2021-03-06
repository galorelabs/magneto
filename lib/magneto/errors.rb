module Magneto
  class Error < RuntimeError
  end

  class ConfigError < Error
    def initialize
      super 'api_user, api_key and at least one wsdl should be present'
    end
  end

  class LoginError < Error
    def initialize(response)
      super response.inspect
    end
  end
  class SoapError < Error
    def initialize(response)
      super response.inspect
    end
  end
  class CartError < Error
    def initialize(msg)
      super msg
    end
  end
end
