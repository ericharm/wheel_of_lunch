# spec/app_spec.rb
require 'faker'
require File.expand_path '../spec_helper.rb', __FILE__
require File.expand_path '../../src/option.rb', __FILE__

describe "options" do
  before(:each) do
    @option = Option.create(
      name: Faker::Company.name,
      default_on: [0, 1].sample,
      ip: Faker::Internet.public_ip_v4_address
    )
  end

  after(:context) do
    Option.all.each { |o| o.delete }
    file = File.delete("./db/test.sqlite")
  end
  
  describe "#get /options" do
    it "should return that options as json" do
      get '/options'
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql("[#{@option.to_json}]")
    end
  end
end
