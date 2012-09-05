module Magneto
  class Error < RuntimeError
  end

  class ConfigError < Error
    def initialize
      super 'api_user, api_key and at least one wsdl should be present'
    end
  end
end
