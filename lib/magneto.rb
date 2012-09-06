require "magneto/config"
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

  attr_writer :config
end
