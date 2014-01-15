require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./rake/soap_fixture"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

task :fixture_catalog_category_tree do
  puts "Generating catalog_category_tree.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :catalog_category_tree
end

task :fixture_login do
  puts "Generating login.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :login, message: {username: 'omsapi', api_key: 'asdfgh'}
end

task :fixture_login_fail do
  puts "Generating login_fail.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :login, 
    {message: {username: 'omsapi', api_key: 'wrong-api-key'}}, 
    'login_fail'
end

task :fixture_catalog_product_list do
  puts "Generating catalog_product_list.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :catalog_product_list
end

task :fixture_catalog_inventory_stock_item_list do
  puts "Generating catalog_inventory_stock.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :catalog_inventory_stock_item_list , 
    message: {session_id: soap_fixture.session_id, products: soap_fixture.soap_array('product', soap_fixture.sample_skus)}
end

task :fixture_catalog_product_info do
  puts "Generating catalog_product_info.xml..."
  attr = {
    'attributes' => {'a1' => 'name','a2' => 'price', 'a3' => 'description', 'a4' => 'status', 'a5' => 'visibility'},
    'additional_attributes' => {'a1' => 'color', 'a2' => 'size', 'a3' => 'special_price'}
  }
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :catalog_product_info,
    message: {session_id: soap_fixture.session_id, product: soap_fixture.sample_skus[0], :identifierType => 'SKU', :attributes => attr}    
end

task :fixture_catalog_product_attribute_media_list do
  soap_fixture = SoapFixture.new
  soap_fixture.login_then.make_fixture_for :catalog_product_attribute_media_list,
    message: {session_id: soap_fixture.session_id, product: soap_fixture.sample_skus[0]}
end
