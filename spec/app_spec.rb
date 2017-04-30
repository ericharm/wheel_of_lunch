require 'faker'
require File.expand_path '../spec_helper.rb', __FILE__
require File.expand_path '../../src/option.rb', __FILE__

def random_option
  { :name => Faker::Company.name,
    :default_on => false,
    :ip => Faker::Internet.public_ip_v4_address }
end

describe "options" do
  before(:each) do
    @option = Option.create(random_option)
  end

  after(:each) do
    Option.all.each { |o| o.delete }
  end

  describe "#get /" do
    it "should return a view" do
      get '/'
      expect(last_response.body).to include('<title>Wheel Of Food</title>')
    end
  end

  describe "#get /options" do
    it "should return that option as json" do
      get '/options'

      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql("[#{@option.to_json}]")
    end
  end

  describe "#post /option" do
    it "should add a new non-default option to the db" do
      name = Faker::Company.name
      data = { :name => name }
      post '/option', data.to_json

      expect(last_response.status).to eql(201)
      expect(Option.last.name).to eql(name)
      expect(Option.last.default_on).to eql(false)
      expect(Option.all.length).to eql(2)
    end
  end

  
end

