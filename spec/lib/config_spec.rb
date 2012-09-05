require "spec_helper"

describe Magneto::Config do
  it "allows to change the default values" do
    Magneto.configure do |config|
      config.log = false
      config.log.should eq false
    end
  end
end
