
::APP_ROOT = "#{File.dirname(File.expand_path(__FILE__))}/fixtures" 

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV['RACK_ENV'] = 'test'

#--
# DEPENDENCIES
#++
%w( 
sinatra/base 
fileutils
sass
ostruct
yaml
json
).each {|lib| require lib }

#--
## SINATRA EXTENSIONS
#++
%w(
sinatra/tests
sinatra/cache
).each {|ext| require ext }


Spec::Runner.configure do |config|
  config.include RspecHpricotMatchers
  config.include Sinatra::Tests::TestCase
  config.include Sinatra::Tests::RSpec::SharedSpecs
end


# quick convenience methods..

def fixtures_path 
  "#{File.dirname(File.expand_path(__FILE__))}/fixtures"
end

def public_fixtures_path 
  "#{fixtures_path}/public"
end

def test_cache_path(ext='')
  "/tmp/sinatra-cache/#{ext}"
end

class MyTestApp < Sinatra::Base 
  
  set :app_dir, "#{APP_ROOT}/apps/base"
  set :public, "#{fixtures_path}/public"
  set :views, "#{app_dir}/views"
  
  register(Sinatra::Tests)
  
  enable :raise_errors
  
end #/class MyTestApp


class Test::Unit::TestCase
  Sinatra::Base.set :environment, :test
end
