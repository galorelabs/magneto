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
    @config ||= Config.default
  end
  
  def client
    @client
  end
  
  def self.product(options = {})
    @@product ||= Magneto::Product.new(options)
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
