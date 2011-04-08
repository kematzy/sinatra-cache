
require 'sinatra/outputbuffer'

module Sinatra
  module Cache
    VERSION = '0.3.7' unless const_defined?(:VERSION)
    def self.version; "Sinatra::Cache v#{VERSION}"; end
  end #/ Cache
end #/ Sinatra

%w(templates cache/helpers).each do |lib| 
  require "sinatra/#{lib}" 
end
