module Magneto
  Config = Struct.new(:log, :wsdl_v1, :wsdl_v2) do
    def self.default
      config = new
      config.log = true
      config
    end
  end
end
