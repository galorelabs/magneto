require 'magneto'
require 'equivalent-xml'

def stub_login(success=true)
  if success
    return_value = {:login_response=>{:login_return=>"7ab1f29cd18ac06f309c89ba96517ada"}}
  else
    return_value =  {:fault => {:faultcode => "2", :faultstring => "Access denied."}}
  end 
  Savon::Client.any_instance.should_receive(:request).with(:login, :body => { :username => Magneto.config.api_user , :api_key => Magneto.config.api_key }).and_return return_value
end

def config_magneto
  Magneto.configure do |config|
    config.api_user = 'foo'
    config.api_key = 'bar'
    config.wsdl_v1 = 'http://www.example.com/wdsl'
  end
end


