# vendor_sinatra = "#{File.dirname(File.dirname(__FILE__))}/vendor/sinatra"
# puts vendor_sinatra
# $LOAD_PATH.unshift "#{vendor_sinatra}/lib" if test(?d, vendor_sinatra)

path_2_my_lib = File.expand_path('../lib')
$LOAD_PATH.unshift path_2_my_lib

require 'rubygems'
require 'sinatra/base'
begin
  require 'test/spec'
rescue LoadError
  raise "These tests depends upon the Test-Spec gem  [sudo gem install test-spec]"
end
require 'sinatra/test'


# The code below was lovingly plagiarized from Sinatra.

class Sinatra::Base
  # Allow assertions in request context
  include Test::Unit::Assertions
end

class Test::Unit::TestCase
  include Sinatra::Test
  
  def setup
    Sinatra::Default.set :environment, :test
  end
  
  # Sets up a Sinatra::Base subclass defined with the block
  # given. Used in setup or individual spec methods to establish
  # the application.
  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end
  
  def restore_default_options
    Sinatra::Default.set(
      :environment => :development,
      :raise_errors => Proc.new { test? },
      :dump_errors => true,
      :sessions => false,
      :logging => Proc.new { ! test? },
      :methodoverride => true,
      :static => true,
      :run => Proc.new { ! test? }
    )
  end
  
  # quick convenience methods..
  
  def fixtures_path
    "#{File.dirname(File.expand_path(__FILE__))}/fixtures"
  end
  
  def public_fixtures_path
    "#{fixtures_path}/public"
  end
  
end
