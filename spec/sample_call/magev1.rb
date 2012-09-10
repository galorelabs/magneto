require 'rubygems'
require 'savon'

Savon.configure do |config|
  config.log = false
  config.log_level = :info
  #config.logger = Rails.logger
  #config.pretty_print_xml = true
  config.raise_errors = false
  #config.env_namespace = :soapenv
  #config.soap_header = { auth: { username: "admin", password: "secret" } }
end
HTTPI.log = false



base_url = "http://jeckerson.stage.h-art.it"
username = 'testapi'
api_key = 'fa44066d7b30a9cc0f0dea46f57b3cf3'

client = Savon::Client.new "#{base_url}/index.php/api/soap/?wsdl"

#login
response = client.request :login, :body => { :username => username, :api_key => api_key }
puts response.to_hash.inspect
session_id = response.to_hash[:login_response][:login_return]


puts response.to_hash.inspect

#create cart
response = client.request :call, :body => {  :session_id => session_id,  'resourcePath' => 'cart.create' }
cart_id = response.to_hash[:call_response][:call_return]


puts response.to_hash.inspect


response = client.request :call do |soap|
  soap.xml = <<-eos
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns2="http://xml.apache.org/xml-soap" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <SOAP-ENV:Body>
        <ns1:call>
            <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
            <resourcePath xsi:type="xsd:string">cart_product.add</resourcePath>
            <args SOAP-ENC:arrayType="xsd:ur-type[2]" xsi:type="SOAP-ENC:Array">
                <item xsi:type="xsd:int">#{cart_id}</item>
                <item SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array">
                    <item xsi:type="ns2:Map">
                        <item>
                            <key xsi:type="xsd:string">product_id</key>
                            <value xsi:type="xsd:int">9987</value>
                        </item>
                        <item>
                            <key xsi:type="xsd:string">quantity</key>
                            <value xsi:type="xsd:int">1</value>
                        </item>
                    </item>
                    <item xsi:type="ns2:Map">
                        <item>
                            <key xsi:type="xsd:string">product_id</key>
                            <value xsi:type="xsd:int">9884</value>
                        </item>
                        <item>
                            <key xsi:type="xsd:string">quantity</key>
                            <value xsi:type="xsd:int">1</value>
                        </item>
                    </item>
                </item>
            </args>
        </ns1:call>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
eos

end

puts response.to_hash.inspect

exit

response = client.request :call do |soap|
  soap.xml = <<-eos
    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns2="http://xml.apache.org/xml-soap" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <SOAP-ENV:Body>
        <ns1:call>
          <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
          <resourcePath xsi:type="xsd:string">cart_customer.set</resourcePath>
          <args SOAP-ENC:arrayType="xsd:ur-type[2]" xsi:type="SOAP-ENC:Array">
            <item xsi:type="xsd:int">#{cart_id}</item>
            <item xsi:type="ns2:Map">
              <item>
                <key xsi:type="xsd:string">firstname</key>
                <value xsi:type="xsd:string">Matteo</value>
              </item>
              <item>
                <key xsi:type="xsd:string">lastname</key>
                <value xsi:type="xsd:string">Parmi</value>
              </item>
              <item>
                <key xsi:type="xsd:string">website_id</key>
                <value xsi:type="xsd:string">1</value>
              </item>
              <item>
                <key xsi:type="xsd:string">group_id</key>
                <value xsi:type="xsd:string">1</value>
              </item>
              <item>
                <key xsi:type="xsd:string">store_id</key>
                <value xsi:type="xsd:string">1</value>
              </item>
              <item>
                <key xsi:type="xsd:string">email</key>
                <value xsi:type="xsd:string">teo@blomming.com</value>
              </item>
              <item>
                <key xsi:type="xsd:string">mode</key>
                <value xsi:type="xsd:string">guest</value>
              </item>
              </item>
            </args>
          </ns1:call>
       </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
  eos
end

puts response.to_hash.inspect

response = client.request :call do |soap|
  soap.xml = <<-eos
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns2="http://xml.apache.org/xml-soap" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <SOAP-ENV:Body>
        <ns1:call>
            <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
            <resourcePath xsi:type="xsd:string">cart_customer.addresses</resourcePath>
            <args SOAP-ENC:arrayType="xsd:ur-type[2]" xsi:type="SOAP-ENC:Array">
                <item xsi:type="xsd:int">#{cart_id}</item>
                <item SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array">
                    <item xsi:type="ns2:Map">
                    <item>
                    <key xsi:type="xsd:string">mode</key>
                    <value xsi:type="xsd:string">shipping</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">firstname</key>
                    <value xsi:type="xsd:string">Matteo</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">lastname</key>
                    <value xsi:type="xsd:string">Parmi</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">company</key>
                    <value xsi:type="xsd:string">Blomming</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">street</key>
                    <value xsi:type="xsd:string">Via teodosio 65</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">city</key>
                    <value xsi:type="xsd:string">Milano</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">region</key>
                    <value xsi:type="xsd:string">MI</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">postcode</key>
                    <value xsi:type="xsd:string">20100</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">country_id</key>
                    <value xsi:type="xsd:string">IT</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">telephone</key>
                    <value xsi:type="xsd:string">0123456789</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">fax</key>
                    <value xsi:type="xsd:string">0123456789</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">is_default_shipping</key>
                    <value xsi:type="xsd:int">0</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">is_default_billing</key>
                    <value xsi:type="xsd:int">0</value>
                </item>
            </item>
            <item xsi:type="ns2:Map">
                <item>
                <key xsi:type="xsd:string">mode</key>
                <value xsi:type="xsd:string">billing</value>
            </item>
                            <item>
                    <key xsi:type="xsd:string">firstname</key>
                    <value xsi:type="xsd:string">Matteo</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">lastname</key>
                    <value xsi:type="xsd:string">Parmi</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">company</key>
                    <value xsi:type="xsd:string">Blomming</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">street</key>
                    <value xsi:type="xsd:string">Via teodosio 65</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">city</key>
                    <value xsi:type="xsd:string">Milano</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">region</key>
                    <value xsi:type="xsd:string">MI</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">postcode</key>
                    <value xsi:type="xsd:string">20100</value>
                </item>
                <item>
                    <key xsi:type="xsd:string">country_id</key>
                    <value xsi:type="xsd:string">IT</value>
                </item>
            <item>
                <key xsi:type="xsd:string">telephone</key>
                <value xsi:type="xsd:string">0123456789</value>
            </item>
            <item>
                <key xsi:type="xsd:string">fax</key>
                <value xsi:type="xsd:string">0123456789</value>
            </item>
            <item>
                <key xsi:type="xsd:string">is_default_shipping</key>
                <value xsi:type="xsd:int">0</value>
            </item>
            <item>
                <key xsi:type="xsd:string">is_default_billing</key>
                <value xsi:type="xsd:int">0</value>
            </item>
        </item>
    </item>
</args>
</ns1:call>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
eos
end
puts response.to_hash.inspect

response = client.request :call do |soap|
  soap.xml = <<-eos
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <SOAP-ENV:Body>
        <ns1:call>
            <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
            <resourcePath xsi:type="xsd:string">cart_shipping.method</resourcePath>
            <args SOAP-ENC:arrayType="xsd:ur-type[2]" xsi:type="SOAP-ENC:Array">
                <item xsi:type="xsd:int">#{cart_id}</item>
                <item xsi:type="xsd:string">flatrate_flatrate</item>
            </args>
        </ns1:call>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
eos
end
puts response.to_hash.inspect

response = client.request :call do |soap|
  soap.xml = <<-eos
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns2="http://xml.apache.org/xml-soap" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <SOAP-ENV:Body>
        <ns1:call>
            <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
            <resourcePath xsi:type="xsd:string">cart_payment.method</resourcePath>
            <args SOAP-ENC:arrayType="xsd:ur-type[2]" xsi:type="SOAP-ENC:Array">
                <item xsi:type="xsd:int">#{cart_id}</item>
                <item xsi:type="ns2:Map">
                    <item>
                    <key xsi:type="xsd:string">method</key>
                    <value xsi:type="xsd:string">checkmo</value>
                </item>
            </item>
        </args>
    </ns1:call>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
  eos
end

puts response.to_hash.inspect

response = client.request :call do |soap|
  soap.xml = <<-eos
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:Magento" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <SOAP-ENV:Body>
        <ns1:call>
           <sessionId xsi:type="xsd:string">#{session_id}</sessionId>
            <resourcePath xsi:type="xsd:string">cart.order</resourcePath>
            <args SOAP-ENC:arrayType="xsd:ur-type[3]" xsi:type="SOAP-ENC:Array">
                <item xsi:type="xsd:int">#{cart_id}</item>
                <item xsi:nil="true"/>
                <item xsi:nil="true"/>
            </args>
        </ns1:call>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope> 
  eos
end

puts response.to_hash.inspect
