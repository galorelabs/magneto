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

    def cart_shipping_method(method)
      [@header, "<item xsi:type=\"xsd:string\">#{method}</item>", @footer].join
    end

    def cart_payment_method(method)
      [@header, "<item xsi:type=\"ns2:Map\"><item><key xsi:type=\"xsd:string\">method</key><value xsi:type=\"xsd:string\">#{method}</value></item></item>", @footer].join
    end

    def cart_order(options)
      [@header, '<item xsi:nil="true"/><item xsi:nil="true"/>', @footer].join
    end
    
    def cart_customer_set(user)
      template = CartCustomer.new
      template[:firstname] = user[:firstname]
      template[:lastname] = user[:lastname]
      template[:email] = user[:email]
      [@header, template.render, @footer].join
    end
    
    def cart_customer_addresses(user)
      template = CartCustomerAddresses.new
      template[:shipping_address] = user[:shipping_address]
      template[:billing_address] = user[:billing_address]
      [@header, template.render, @footer].join
    end

  end
  class CartCustomer < ::Mustache; end
  class CartCustomerAddresses < ::Mustache; end
  class Products < ::Mustache; end
  class Header < ::Mustache; end
  class Footer < ::Mustache;end
end


