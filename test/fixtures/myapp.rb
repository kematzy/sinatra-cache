## MYAPP.rb
## Simple example app of how to use the Sinatra::Cache plugin in a new 'Sub-Classed' Sinatra app 
## that inherits from Sinatra::Base

require "rubygems"
require "sinatra/base"
require 'sinatra/cache'

class MyApp < Sinatra::Base
  
  register Sinatra::Cache
  
  enable :logging
  enable :static
  
  set :public, "#{File.dirname(__FILE__)}/public"
  set :views, "#{File.dirname(__FILE__)}/views"
  
  get '/' do
    erb(:index)
  end
  
  get '/cache' do
    cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
  end
  
  # YES, I know this is NOT ideal, but it's only a test ;-)
  get '/cache_expire' do
    cache_expire("/cache")
  end
  
end

MyApp.run!(:port => 4568) if __FILE__ == $0

#/EOF