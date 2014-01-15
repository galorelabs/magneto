require 'savon'
require 'nokogiri'

class SoapFixture
  
  def initialize
    @client = Savon::Client.new(wsdl: "http://magento.galoretv.com/index.php/api/v2_soap?wsdl=1",
      raise_errors: false) 
    @username = 'omsapi'
    @api_key = 'asdfgh'
  end
  
  def sample_skus
    ['n2610', 'bb8100', 'sw810i']
  end

  def soap_array(name,array)
    hash = {}
    array.each_with_index do |e, i|
      hash["#{name}-#{i}"] = e
    end
    hash
  end
  
  def session_id
    if @session_id.nil?
      raise Exception.new "Login is required"
    end
    @session_id
  end

  def login_then
    @response = @client.call :login, message: {username: @username, 
      api_key: @api_key}    
    @session_id = @response.to_hash[:login_response][:login_return]
    self #to make this chainable!
  end

  def make_fixture_for(api_method,  api_body = nil, xml_file = nil)
    response = @client.call api_method, api_body || {message: {session_id: @session_id}}
    doc = Nokogiri.XML(response.to_xml) do |config|
      config.default_xml.noblanks
    end
    
    xml_file = xml_file || api_method.to_s
    
    puts "Writing spec/fixture/#{xml_file}.xml"
    File.open("spec/fixture/#{xml_file}.xml", 'w+') {|f| f.write(doc)}
  end 
  
  
end