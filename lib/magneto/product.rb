module Magneto
  class Product
    attr_accessor :username, :api_key, :client, :session_id

    def initialize(options = {})      
      if Magneto.mock?
        @client = Magneto.client  
      else
        @client = Savon::Client.new(wsdl: (options[:wsdl_v2] || Magneto.config.wsdl_v2)) 
      end
    
      
      @username = options[:api_user] || Magneto.config.api_user
      @api_key = options[:api_key] || Magneto.config.api_key
      @categories = []
      login
    end

    def login
      response = @client.call :login, message: { :username => @username, :api_key => @api_key }
      @session_id = response.to_hash[:login_response][:login_return]
      @session_id
    end

    # addedd filters, eg for filter by status = 1:
    # filter = {'filters' =>
    #           {'complex_filter' =>
    #            {'item' =>
    #             {'key'=>'status',
    #              'value' =>  {'key' => 'in', 'value' => '1'}
    #             }
    #            }
    #           }
    #          }
    
    def products_list(filters = {})
      response = @client.call :catalog_product_list, message: { :session_id => @session_id}.merge(filters)
      response.to_hash[:catalog_product_list_response][:store_view][:item]
    end

    def call(method, options = {})
      opt =  {:session_id => @session_id}.merge options
      response = @client.request :web, method.to_sym, :body => opt
      response.to_hash["#{method}_response".to_sym] || response.to_hash
    end

    def ensure_session_alive
      response = yield
      if response.has_key?(:fault)
        if response[:fault][:faultcode] == "5"
          login
          response = yield
        end
      end
      response
    end

    def stock_info(skus)
      response = ensure_session_alive do
        response = @client.call :catalog_inventory_stock_item_list, :message => { :session_id => @session_id, :products => soap_array('product', skus) }
        response = response.to_hash
      end
      #raise Magneto::SoapError.new(response) if response.has_key? :fault
      raise Magneto::SoapError.new("#products #{skus.inspect} not exists, response : #{response.to_hash.inspect}") unless response[:catalog_inventory_stock_item_list_response][:result].has_key? :item
      response = response.to_hash[:catalog_inventory_stock_item_list_response][:result][:item]
      if response.is_a? Array
        ret = response
      else
        ret = [response]
      end
      ret.map{ |s| {s[:sku] => { :qty => s[:qty], :is_in_stock => s[:is_in_stock] } , s[:product_id] => { :qty => s[:qty], :is_in_stock=> s[:is_in_stock] } } }.inject {|a, b| a.merge b }
      #return a hash like:
      #{"10I1J2DPA040287-X0004-25"=>{:qty=>"0.0000", :is_in_stock=>"0"}, "10I1J2DPA040287-X0004-28"=>{:qty=>"0.0000", :is_in_stock=>"0"}, "22PCJDMAP4XF00091-7020"=>{:qty=>"0.0000", :is_in_stock=>"1"}}
    end

    # price rules array can define global discount mapped to magento > promotions > catalog price rules.
    # At this time magento does not provide a way to pull out these price rules via soal api, so they need to be
    # hardcoded.
    # it's an array of hashes like:

    price_rules = [
      {:categories => [1,2,3], :type => :percentage, :amount => 50},
      {:categories => [4,5,6], :type => :amount, :amount => 30},
    ]

    def product_details(sku, price_rules = nil)
      attr = {
        'attributes' => {'a1' => 'name','a2' => 'price', 'a3' => 'description', 'a4' => 'status', 'a5' => 'visibility'},
        #'additionalAttributes' => {'a1' => 'color'},
        'additional_attributes' => {'a1' => 'color', 'a2' => 'size', 'a3' => 'special_price'}
      }
      response = ensure_session_alive do
        response = @client.call :catalog_product_info, :message => { :session_id => @session_id, :product => sku, :identifierType => 'SKU', :attributes => attr}
        response = response.to_hash
      end
      raise Magneto::SoapError.new(response) if response.has_key? :fault
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
      response = @client.call :catalog_product_attribute_media_list, :message => { :session_id => @session_id, :product => sku}
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
      #return @categories unless @categories.empty?
      response = @client.call :catalog_category_tree, message: { :session_id => @session_id}
      #response.to_hash[:catalog_category_tree_response][:tree][:children][:item]
      #parse_categories response.to_hash[:catalog_category_tree_response][:tree][:children][:item]
      #@categories
      @cat_response = response.to_hash[:catalog_category_tree_response][:tree][:children][:item] 
       if @cat_response
         @cat_array_to_parse = (@cat_response.is_a? Array) ? @cat_response : [@cat_response]
         parse_categories @cat_array_to_parse
       end
       @categories
    end

    def parse_categories(cat)
      cat.each do |c|
        @categories << {
          :id => c[:category_id].to_i,
          :name => c[:name],
          :position => c[:position].to_i,
          :level => c[:level].to_i,
          :is_active => c[:is_active].to_i,
          :parent_id => c[:parent_id].to_i
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


