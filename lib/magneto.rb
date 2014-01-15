require "magneto/product"
require "magneto/xml_template"
require "magneto/config"
require "magneto/cart"
require "magneto/session"
require "magneto/version"
require "magneto/errors"
require 'savon'

module Magneto
  extend self

  def configure
    yield config
  end

  def config
    if mock?
      Config.mock
    else
      @config ||= Config.default  
    end
    
  end
  
  def client
  #as per solution to Savon issue https://github.com/savonrb/savon/issues/396
  #savon.mock! doesn't prevent the SOAP call      
    if mock?
      return Savon.client({
      :endpoint  => "http://example.com",
      :namespace => "http://v1.example.com",
      :log       => false
    })
    else
      @client ||= Savon.client(wsdl: Magneto.config.wsdl_v2)  
    end    
  end
  
  def self.product(options = {})
    @@product ||= Magneto::Product.new(options)
  end

  
  def mock?
    !Savon.observers.empty?
  end
  
  
  attr_writer :config, :client
  
  def savon_configure
    {
      log: false,
      log_level: :info,
      raise_errors: false
    }
  end
   

  HTTPI.log = false
end
