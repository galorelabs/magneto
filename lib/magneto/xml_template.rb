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
      template = Products.new
      template[:products] = []
      products.each do |product|
        product_id = product.keys.first
        quantity = product[product_id]
        template[:products] << {:product_id => product_id, :quantity => quantity}
      end
      [@header, template.render, @footer].join
    end

    def cart_shipping_method(shipping_method)
      [@header, '<item xsi:type="xsd:string">flatrate_flatrate</item>', @footer].join
    end

    def cart_payment_method(options)
      [@header, '<item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">method</key><value xsi:type="xsd:string">checkmo</value></item></item>', @footer].join
    end

    def cart_order(options)
      [@header, '<item xsi:nil="true"/><item xsi:nil="true"/>', @footer].join
    end
    
    def cart_customer_set(user)
      [@header, 'foo', @footer].join
    end


  end
  class Products < ::Mustache
  end
  class Header < ::Mustache
  end
  class Footer < ::Mustache
  end
end


