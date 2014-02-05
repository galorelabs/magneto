
#TODO: Write tests, remove copy paste.
#Right now we just need to make this work.
module Magneto

	# Wrapper for http://www.magentocommerce.com/api/soap/sales/salesOrder/salesOrder.html
	class SalesOrder
	
	  ############################Start: Direct from product.rb
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
	##############################End: Direct from product.rb
	
		def list(filters = {})
			 response = @client.call :sales_order_list, message: { :session_id => @session_id}.merge(filters)
			 response = response.to_hash[:sales_order_list_response][:result][:item]
			 return response
		end    
    
	end
end