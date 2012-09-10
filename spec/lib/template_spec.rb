require 'spec_helper'

describe Magneto::XmlTemplate do
  it 'should render header with token, cart_id and resource path' do
    template = Magneto::XmlTemplate.new('token', 'cart_id', 'resource_path')
    template.header.should include 'token', 'cart_id', 'resource_path'
  end
end
