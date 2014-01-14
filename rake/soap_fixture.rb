require 'savon'
require 'nokogiri'

class SoapFixture
  
  def initialize
    @client = Savon::Client.new(wsdl: "http://magento.galoretv.com/index.php/api/v2_soap?wsdl=1") 
    @username = 'omsapi'
    @api_key = 'asdfgh'
  end

  def soap_array(name,array)
    hash = {}
    array.each_with_index do |e, i|
      hash["#{name}-#{i}"] = e
    end
    hash
  end

  def login
    @response = @client.call :login, message: {username: @username, 
      api_key: @api_key}    
    @session_id = @response.to_hash[:login_response][:login_return]
    @session_id
  end

  def make_fixture_for(api_method,  response_file_name=nil, api_body = nil)
    response = @client.call api_method, api_body || {message: {session_id: @session_id}}
    doc = Nokogiri.XML(response.to_xml) do |config|
      config.default_xml.noblanks
    end
    
    response_file_name = response_file_name || api_method.to_s
    
    puts "Writing spec/fixture/#{response_file_name}.xml"
    File.open("spec/fixture/#{response_file_name}.xml", 'w+') {|f| f.write(doc)}
  end 
  
  
end