require 'spec_helper'
require "savon/mock/spec_helper"


describe Magneto::Product  do

  include Savon::SpecHelper
  before(:all) do
    savon.mock! 
    
    #Savon Fixtures
    fixture = File.read("spec/fixture/login.xml")
    savon.expects(:login).with(message: {username: Magneto.config.api_user, 
      api_key: Magneto.config.api_key }).returns(fixture)  
  end
  
  after(:all)  { savon.unmock! }

  it "should be retrievable via Magent.product" do       
    expect(Magneto.product).to be_a Magneto::Product
    expect(Magneto.product).to_not be_nil      
  end
  
  describe "products_list" do
    it "must generate a product list" do
                  
      fixture = File.read("spec/fixture/catalog_product_list.xml")
      savon.expects(:catalog_product_list).with(message: :any).returns(fixture)  
      
      products_list = Magneto.product.products_list
      expect(products_list).to_not be_nil
      expect(products_list).to be_an Array
      
      expect(products_list[0][:product_id]).to eq("16")
      expect(products_list[0][:sku]).to eq("n2610")
      expect(products_list[0][:name]).to eq("Nokia 2610 Phone")
      expect(products_list[0][:set]).to eq("38")
      expect(products_list[0][:type]).to eq("simple")
    end
  end
  
  describe "categories" do
    it "must generate a parsed set of categories" do
      
      fixture = File.read("spec/fixture/catalog_category_tree.xml")
      savon.expects(:catalog_category_tree).with(message: :any).returns(fixture) 
      
      categories = Magneto.product.categories

      expect(categories).to be_an Array
      
      expect(categories[0][:id]).to eq(3)
      expect(categories[0][:name]).to eq("Root Catalog")
      expect(categories[0][:is_active]).to eq(1)
      expect(categories[0][:position]).to eq(3)
      expect(categories[0][:level]).to eq(1)
      expect(categories[0][:parent_id]).to eq(1)
 
      expect(categories[1][:id]).to eq(10)
      expect(categories[1][:name]).to eq("Furniture")
      expect(categories[1][:is_active]).to eq(1)
      expect(categories[1][:position]).to eq(10)
      expect(categories[1][:level]).to eq(2)
      expect(categories[1][:parent_id]).to eq(3)           
    end    
  end
  
  describe "stock_info" do
    it "must display quantity of product" do

      fixture = File.read("spec/fixture/catalog_inventory_stock_item_list.xml")
      savon.expects(:catalog_inventory_stock_item_list).with(message: :any).returns(fixture) 
      
      stock_info = Magneto.product.stock_info(['n2610', 'bb8100', 'sw810i'])
      
      expect(stock_info['n2610'][:qty]).to eq("996.0000")
      expect(stock_info['n2610'][:is_in_stock]).to eq("1")
      
      expect(stock_info['bb8100'][:qty]).to eq("797.0000")
      expect(stock_info['bb8100'][:is_in_stock]).to eq("1")            
    end
  end
  
  describe "product_details" do
    it "displays product details" do
      
      fixture = File.read("spec/fixture/catalog_product_info.xml")
      savon.expects(:catalog_product_info).with(message: :any).returns(fixture)
      
      product_details = Magneto.product.product_details('n2610')
      
      expect(product_details[:product_id]).to eq("16")
      expect(product_details[:sku]).to eq("n2610")
      expect(product_details[:type]).to eq("simple")
      expect(product_details[:name]).to eq("Nokia 2610 Phone")

      expect(product_details[:price]).to eq("149.9900")
      expect(product_details[:special_price]).to be_nil
      expect(product_details[:size]).to be_nil
      expect(product_details[:color]).to eq("24")      
      end
    end
    
    describe "product_images" do
      
    end
  
end


