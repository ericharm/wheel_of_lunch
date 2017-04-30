require 'sinatra/base'
require 'active_record'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require './src/option'

class Wheel < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

  # home
  get '/' do
    status 200
    erb :index
  end

  # options
  # index
  get '/options' do
    content_type :json
    status 200
    options = Option.all.to_json
    body options 
  end

  # create
  post '/option' do
    data = JSON.parse(request.body.read)

    option = Option.create(
      name: data["name"],
      default_on: false,
      ip: request.ip
    )

    content_type :json

    if option && option.errors.messages.blank?
      status 201
      response = {
        status: 'success', data: option.to_json
      }
      body response.to_json
    else
      status 400
      response = {
        status: "error", message: "Option could not be created"
      }
      body response.to_json
    end
  end
end

