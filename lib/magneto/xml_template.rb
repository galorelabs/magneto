require 'mustache'

Mustache.template_path = File.join File.dirname(__FILE__), '../../templates'
Mustache.template_extension = 'xml'


module Magneto
  class XmlTemplate
    attr_reader :header
    def initialize(token, cart_id, resource_path)
      header = Header.new
      header[:token] = token
      header[:cart_id] = cart_id
      header[:resource_path] = resource_path
      @header = header.render
      @footer = Footer.new.render
    end

    def cart_product_add(products)
      template = Products.new.render
      [@header, template, @footer].join
    end
  end
  class Products < ::Mustache
  end
  class Header < ::Mustache
  end
  class Footer < ::Mustache
  end
end


