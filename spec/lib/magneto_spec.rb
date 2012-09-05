require 'spec_helper'

describe Magneto::Session do
  it 'should login and return session data' do
    m = Magento::Session.new('login','pw')
    m.session_id.should == 'sesid'
  end
end
