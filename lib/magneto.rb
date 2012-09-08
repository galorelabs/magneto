require "magneto/product"
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
  
  def self.product
    @@product ||= Magneto::Product.new
  end

  attr_writer :config, :client
  Savon.configure do |config|
    config.log = false
    config.log_level = :info
    config.raise_errors = false
  end
  HTTPI.log = false
end
