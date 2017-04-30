require 'sinatra/base'
require 'active_record'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require './src/option'

#move this db stuff out of here
#def connect_to_db(db_filename)
  #ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => "db/#{db_filename}"
  #I18n.enforce_available_locales = false
   #ActiveRecord::Base.logger = Logger.new(STDOUT)
   #ActiveSupport::LogSubscriber.colorize_logging = false
#end

#def get_db_filename(env)
  #return 'test.sqlite' if env == 'test'
  #return 'wheel.sqlite'
#end

#db_filename =  get_db_filename(ENV['RACK_ENV'])
#DatabaseInitializer.initialize_db("db/#{db_filename}")
#connect_to_db(db_filename)


class Wheel < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

  # home
  get '/' do
    status 200
    body "hello\n"
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
    option = Option.create(
      name: params[:name],
      default_on: 0,
      ip: request.ip
    )

    content_type :json

    if option
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
