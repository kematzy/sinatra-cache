# vendor_sinatra = "#{File.dirname(File.dirname(__FILE__))}/vendor/sinatra"
# puts vendor_sinatra
# $LOAD_PATH.unshift "#{vendor_sinatra}/lib" if test(?d, vendor_sinatra)

# begin
#   require 'sinatra/base'
# rescue LoadError
#   require 'rubygems'
#   require 'sinatra/base'
# end

libdir = File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)
require 'rubygems'
# require "#{vendor_sinatra}/lib/sinatra/base"
# require "#{vendor_sinatra}/lib/sinatra/base"
# require "#{vendor_sinatra}/lib/sinatra/test/unit"
# require "#{vendor_sinatra}/lib/sinatra/test/spec"

require 'sinatra/base'
require 'sinatra/test/spec'

class Sinatra::Base
  # Allow assertions in request context
  include Test::Unit::Assertions
end

class Test::Unit::TestCase
  include Sinatra::Test

  def setup
    Sinatra::Default.set(
      :environment => :test,
      :run => false,
      :raise_errors => true,
      :logging => false
    )
  end

  # Sets up a Sinatra::Base subclass defined with the block
  # given. Used in setup or individual spec methods to establish
  # the application.
  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end

  def restore_default_options
    Sinatra::Default.set(
      :raise_errors => Proc.new { test? },
      :dump_errors => true,
      :sessions => false,
      :logging => true,
      :methodoverride => true,
      :static => true,
      :run  => false
    )
  end
  
  
  def public_fixtures_path
    "#{File.dirname(__FILE__)}/fixtures/public"
  end
end

