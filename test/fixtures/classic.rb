## CLASSIC.rb
## Simple example app of how to use the Sinatra::Cache plugin in a normal 'Classic' Sinatra app.

require "rubygems"
require "sinatra"
require 'sinatra/cache'

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

#/EOF