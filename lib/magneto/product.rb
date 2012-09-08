module Magneto
  class Product
    attr_accessor :username, :api_key, :client, :session_id

    def initialize()
      @client = Savon::Client.new(Magneto.config.wsdl_v2) 
      @username = Magneto.config.api_user
      @api_key = Magneto.config.api_key
      @categories = []
      login
    end

    def login
      response = @client.request :web, :login, :body => { :username => @username, :api_key => @api_key }
      @session_id = response.to_hash[:login_response][:login_return]
    end

    def products_list
      response = @client.request :web, :catalog_product_list, :body => { :session_id => @session_id}
      response.to_hash[:catalog_product_list_response][:store_view][:item]
    end

    def call(method, options = {})
      opt =  {:session_id => @session_id}.merge options
      puts opt
      response = @client.request :web, method.to_sym, :body => opt
      response.to_hash["#{method}_response".to_sym]
    end

    def stock_info(skus)
      response = @client.request :web, :catalog_inventory_stock_item_list, :body => { :session_id => @session_id, :products => soap_array('product', skus) }
      response = response.to_hash[:catalog_inventory_stock_item_list_response][:result][:item]
      if response.is_a? Array
        ret = response
      else
        ret = [response]
      end
      ret.map{ |s| {s[:product_id] => { :qty => s[:qty],:is_in_stock=> s[:is_in_stock] } } }.inject {|a, b| a.merge b }
      #return a hash like:
      #{"10I1J2DPA040287-X0004-25"=>{:qty=>"0.0000", :is_in_stock=>"0"}, "10I1J2DPA040287-X0004-28"=>{:qty=>"0.0000", :is_in_stock=>"0"}, "22PCJDMAP4XF00091-7020"=>{:qty=>"0.0000", :is_in_stock=>"1"}}
    end

    def product_details(sku)
      attr = {
        'attributes' => {'a1' => 'name','a2' => 'price', 'a3' => 'description', 'a4' => 'status', 'a5' => 'visibility'},
        #'additionalAttributes' => {'a1' => 'color'},
        'additional_attributes' => {'a1' => 'color', 'a2' => 'size', 'a3' => 'special_price'}
      }
      response = @client.request :web, :catalog_product_info, :body => { :session_id => @session_id, :product => sku, :identifierType => 'SKU', :attributes => attr}
      product = response.to_hash[:catalog_product_info_response][:info]
      product.delete(:"@xsi:type")
      product.delete(:set)
      product.delete(:websites)
      #product.delete(:categories)
      attributes = product.delete(:additional_attributes)
      if attributes[:item].is_a? Array
        product[:size] = (attributes[:item].select{|i| i[:key] == 'size'}.first[:value]) rescue nil
        product[:color] = (attributes[:item].select{|i| i[:key] == 'color'}.first[:value]) rescue nil
        product[:special_price] = (attributes[:item].select{|i| i[:key] == 'special_price'}.first[:value]) rescue nil
      else
        product[attributes[:item][:key]] = attributes[:item][:value]
        product[:size] = nil
        product[:color] = nil
      end
      product
    end

    def product_images(sku)
      response = @client.request :web, :catalog_product_attribute_media_list, :body => { :session_id => @session_id, :product => sku}
      if response.to_hash[:catalog_product_attribute_media_list_response][:result][:item]
        imgs = []
        if response.to_hash[:catalog_product_attribute_media_list_response][:result][:item].is_a? Array
          response.to_hash[:catalog_product_attribute_media_list_response][:result][:item].each do |img| 
            imgs << img[:url]
          end
        else
          imgs << response.to_hash[:catalog_product_attribute_media_list_response][:result][:item][:url]
        end
        imgs
      else
        []
      end
    end

    def categories
      return @categories unless @categories.empty?
      response = @client.request :web, :catalog_category_tree, :body => { :session_id => @session_id}
      parse_categories response.to_hash[:catalog_category_tree_response][:tree][:children][:item]
      @categories
    end

    def parse_categories(cat)
      cat.each do |c|
        @categories << {
          :id => c[:category_id],
          :name => c[:name],
          :position => c[:position],
          :level => c[:level],
          :is_active => c[:is_active],
          :parent_id => c[:parent_id]
        }
        parse_categories(c[:children][:item]) if c[:children][:item]
      end
    end

    def category_name(id)
      categories.select {|k| k[:id] == id}.first[:name]
    end

    def soap_array(name,array)
      hash = {}
      array.each_with_index do |e, i|
        hash["#{name}-#{i}"] = e
      end
      hash
    end
  end
end


