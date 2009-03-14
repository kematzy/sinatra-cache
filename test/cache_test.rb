require File.dirname(__FILE__) + '/helper'
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/lib/sinatra/cache"

class Sinatra::Base
  # include Sinatra::Cache
end #/class Sinatra::Base

puts "Test Suite for [#{Sinatra::Cache.version}] produced on [#{ Time.now.strftime("%Y-%d-%m at %H:%M") }]"

describe "Sinatra::Cache" do 
  
  before(:each) do
    
    default_app = mock_app do 
      register Sinatra::Cache
      
      set :public, "#{File.dirname(File.expand_path(__FILE__))}/fixtures/public"
      set :views, "#{File.dirname(File.expand_path(__FILE__))}/fixtures/views"
      
      get '/' do
        erb(:index)
      end
      
      get '/cache' do
        # "Hello World from Sinatra Version=[#{Sinatra::VERSION}]"
        cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
      end
      # YES, I know this is NOT ideal, but it's only test ;-)
      get '/cache_expire' do
        cache_expire("/cache")
      end
      
    end
    
    custom_app = mock_app do
      register Sinatra::Cache
      
      set :public, "#{File.dirname(__FILE__)}/fixtures/public"
      set :views, "#{File.dirname(__FILE__)}/fixtures/views"
      
      set :cache_enabled, false
      set :cache_page_extension, '.cache.html'
      set :cache_output_dir, 'system/cache'
      set :cache_logging, false
      set :cache_logging_level, :info
      
      get '/' do
        erb :index
      end
      
      get '/cache' do
        cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
      end
      # YES, I know this is NOT ideal, but it's only test ;-)
      get '/cache_expire' do
        cache_expire("/cache")
      end
    end
    
    @default_app = default_app.new
    @custom_app = custom_app.new
  end
  
  describe "ClassMethods" do 
    
    describe "the :version method" do 
      
      it "should have a :version method that returns a String with the version number in it" do 
        v = Sinatra::Cache.version
        assert_not_nil(v)
        assert_kind_of(String, v)
        assert_match(/Sinatra::Cache v\d\.\d\.\d/, v)
      end
      
      it "should not interfere with the normal Sinatra VERSION" do 
        assert_not_equal(Sinatra::Cache.version, Sinatra::VERSION)
      end
      
    end #/the :version method
    
  end #/ClassMethods
  
  
  describe "Instance Methods" do 
    
    describe "Private" do 
      
      describe ":cache_file_name method" do 
        
        # temporary monkeypatch to enable testing
        module Sinatra::Cache::Helpers 
          public :cache_file_name
        end
        
        describe "when using default options" do 
          
          it "should handle '/' and return 'index.html'" do 
            expected = "index.html"
            assert_equal(expected, @default_app.cache_file_name("/"))
          end
          
          it "should handle top level URI's and return the URI plus '.html'" do 
            expected = "cache.html"
            assert_equal(expected, @default_app.cache_file_name("/cache"))
          end
          
          it "should handle sub level URIs and return the directory/file format" do 
            expected = "cache/test.html"
            assert_equal(expected, @default_app.cache_file_name("/cache/test"))
          end
          
        end #/when using default options
        
        describe "when using customized options" do 
          
          it "should handle '/' and return 'index.html'" do 
            expected = "index.cache.html"
            assert_equal(expected, @custom_app.cache_file_name("/"))
          end
          
          it "should handle top level URI's and return the URI plus '.html'" do 
            expected = "cache.cache.html"
            assert_equal(expected, @custom_app.cache_file_name("/cache"))
          end
          
          it "should handle sub level URIs and return the directory/file format" do 
            expected = "cache/test.cache.html"
            assert_equal(expected, @custom_app.cache_file_name("/cache/test"))
          end
          
        end #/when using customized options
        
      end #/:cache_page_path method
      
      describe ":cache_page_path method" do 
        
        # temporary monkeypatch to enable testing
        module Sinatra::Cache::Helpers 
          public :cache_page_path
        end
        
        describe "when using default options" do 
          
          it "should handle '/' and return the full path to 'index.html'" do 
            expected = "#{public_fixtures_path}/index.html"
            assert_equal(expected, @default_app.cache_page_path("/"))
          end
          
          it "should handle top level URI's and return the full path to the URI plus '.html'" do 
            expected = "#{public_fixtures_path}/cache.html"
            assert_equal(expected, @default_app.cache_page_path("/cache"))
          end
          
          it "should handle sub level URIs and return the full path to the URI" do 
            expected = "#{public_fixtures_path}/cache/test.html"
            assert_equal(expected, @default_app.cache_page_path("/cache/test"))
          end
          
        end #/when using default options
        
        describe "when using customized options" do 
          
          it "should handle '/' and return the full path to 'index.html'" do 
            expected = "#{public_fixtures_path}/system/cache/index.cache.html"
            assert_equal(expected, @custom_app.cache_page_path("/"))
          end
          
          it "should handle top level URI's and return the full path to the URI plus '.html'" do 
            expected = "#{public_fixtures_path}/system/cache/cache.cache.html"
            assert_equal(expected, @custom_app.cache_page_path("/cache"))
          end
          
          it "should handle sub level URIs and return the full path to the URI" do 
            expected = "#{public_fixtures_path}/system/cache/cache/test.cache.html"
            assert_equal(expected, @custom_app.cache_page_path("/cache/test"))
          end
          
        end #/when using customized options
        
      end #/:cache_page_path method
      
      describe ":log method" do 
        
        it "MISSING TESTS =>" do 
          assert(true)
        end
        
      end #/:log method
      
    end #/Private
    
    describe "Public" do 
      
      describe ":cache method" do 
        
        describe "when using default options" do 
          
          it "is tested below in the Page Caching section" do 
            assert true
          end
          
        end #/when using default options
        
        describe "when using customized options" do 
          
          it "is tested below in the Page Caching section" do 
            assert true
          end
          
        end #/when using customized options
        
      end #/:cache method
      
    end #/Public
    
  end #/Instance Methods
  
  
  describe "configuration methods" do 
    
    describe "when using default options" do 
      
      it "the :cache_enabled option should be correct (true)" do 
        assert_equal(true, @default_app.options.cache_enabled)
      end
      
      it "the :cache_page_extension option should be correct (.html)" do 
        assert_equal('.html', @default_app.options.cache_page_extension)
      end
      
      it "the :cache_output_dir option should be correct ('') " do 
        assert_equal('', @default_app.options.cache_output_dir)
      end
      
      it "the :cache_logging option should be correct (true)" do 
        assert_equal(true, @default_app.options.cache_logging)
      end
      
      it "the :cache_logging_level option should be correct (:info)" do 
        assert_equal(:info, @default_app.options.cache_logging_level)
      end
      
    end #/default options
    
    describe "when using customized options" do 
      
      it "the :cache_enabled option should be correct (false)" do 
        assert_equal(false, @custom_app.options.cache_enabled)
      end
      
      it "the :cache_page_extension option should be correct (.cache.html)" do 
        assert_equal('.cache.html', @custom_app.options.cache_page_extension)
      end
      
      it "the :cache_output_dir option should be correct ('system/cache') " do 
        assert_equal('system/cache', @custom_app.options.cache_output_dir)
      end
      
      it "the :cache_logging option should be correct (true)" do 
        assert_equal(false, @custom_app.options.cache_logging)
      end
      
      it "the :cache_logging_level option should be correct (:info)" do 
        assert_equal(:info, @custom_app.options.cache_logging_level)
      end
      
    end #/when using customized options
    
  end #/configuration methods
  
  
  describe "Page Caching" do 
    after(:each) do
      # FileUtils.rm_r(Dir["#{public_fixtures_path}/*"])
    end
    
    describe "when using default options" do 
      
      it "should NOT cache the un-cached index page" do 
        request = Rack::MockRequest.new(@default_app)
        response = request.get('/')
        assert response
        assert_equal '<h1>HOME</h1>', response.body
        assert_equal(false, test(?f, "#{public_fixtures_path}/index.html"))
      end
      
      it "should cache the /cache page" do 
        request = Rack::MockRequest.new(@default_app)
        response = request.get('/cache')
        assert response
        assert_match(/^Hello World from Sinatra Version=\[\d\.\d\.\d(\.\d)?\]\n/, response.body)
        assert(test(?f, "#{public_fixtures_path}/cache.html"))
        assert_match(/^Hello World from Sinatra Version=\[\d\.\d\.\d(\.\d)?\]\n/, File.read("#{public_fixtures_path}/cache.html"))
      end
      
      it "should expire the /cache page" do 
        assert(test(?f, "#{public_fixtures_path}/cache.html"))
        request = Rack::MockRequest.new(@default_app)
        response = request.get('/cache_expire')
        assert response
        #  TODO:: this is dodgy stuff, rework 
        assert_not_equal('', response.body)
        assert_equal(false, test(?f, "#{public_fixtures_path}/cache.html"))
      end
      
    end #/when using default options
    
    describe "when using customized options" do 
      
      it "should NOT cache the un-cached index page" do 
        request = Rack::MockRequest.new(@custom_app)
        response = request.get('/')
        assert response
        assert_equal '<h1>HOME</h1>', response.body
        assert_equal(false, test(?f, "#{public_fixtures_path}/index.html"))
      end
      
      it "should NOT cache the /cache page since :cache_enabled => false" do 
        request = Rack::MockRequest.new(@custom_app)
        response = request.get('/cache')
        assert response
        assert_match(/^Hello World from Sinatra Version=\[\d\.\d\.\d(\.\d)?\]/, response.body)
        assert_equal(false, test(?f, "#{public_fixtures_path}/cache.cache.html"))
      end
      
      describe "and setting cache_enabled => true" do 
        
        before(:each) do
          custom_enabled_app = mock_app do 
            register Sinatra::Cache
            
            set :public, "#{File.dirname(File.expand_path(__FILE__))}/fixtures/public"
            set :views, "#{File.dirname(File.expand_path(__FILE__))}/fixtures/views"
            
            set :cache_enabled, true
            set :cache_page_extension, '.cache.html'
            set :cache_output_dir, 'system/cache'
            set :cache_logging, true
            set :cache_logging_level, :info
            
            get '/' do
              erb :index
            end
            
            get '/cache' do
              cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
            end
            
            # YES, I know this is NOT ideal, but it's only test ;-)
            get '/cache_expire' do
              cache_expire("/cache")
            end
            
          end
          
          @custom_enabled_app = custom_enabled_app.new
        end
        
        it "should cache the /cache page" do 
          request = Rack::MockRequest.new(@custom_enabled_app)
          response = request.get('/cache')
          assert response
          assert_match(/^Hello World from Sinatra Version=\[\d\.\d\.\d(\.\d)?\]\n<!-- page cached: \d+-\d+-\d+ \d+:\d+:\d+ -->\n$/, response.body)
          assert(test(?f, "#{public_fixtures_path}/system/cache/cache.cache.html"))
          assert_match(/^Hello World from Sinatra Version=\[\d\.\d\.\d(\.\d)?\]\n<!-- page cached: \d+-\d+-\d+ \d+:\d+:\d+ -->\n$/, File.read("#{public_fixtures_path}/system/cache/cache.cache.html"))
        end
        
        it "should expire the /cache page" do 
          assert(test(?f, "#{public_fixtures_path}/system/cache/cache.cache.html"))
          request = Rack::MockRequest.new(@custom_enabled_app)
          response = request.get('/cache_expire')
          assert response
          #  TODO:: this is dodgy stuff, rework 
          assert_not_equal('', response.body)
          assert_equal(false, test(?f, "#{public_fixtures_path}/system/cache/cache.cache.html"))
        end
        
      end #/and setting cache_enabled => true
      
    end #/when using customized options
    
    
  end #/Page Caching
  
  
  describe "Sinatra::Base" do 
    
    before do
      Sinatra::Base.register(Sinatra::Cache)
    end
    
    describe "should respond to" do 
      
      [
        "cache_output_dir", "cache_output_dir=","cache_output_dir?", "cache_enabled","cache_enabled=", "cache_enabled?",
        "cache_logging","cache_logging=","cache_logging?","cache_logging_level","cache_logging_level=","cache_logging_level?",
        "cache_page_extension","cache_page_extension=","cache_page_extension?"
      ].each do |m|
        
        it "the :#{m} method" do 
          assert_respond_to(Sinatra::Base, m.to_sym)
        end
        
      end
      
    end #/should respond to
    
  end #/Sinatra::Base
  
  describe "Sinatra::Default" do 
    
    before do
      Sinatra::Base.register(Sinatra::Cache)
    end
    
    describe "should respond to" do 
      
      [
        "cache_output_dir", "cache_output_dir=","cache_output_dir?", "cache_enabled","cache_enabled=", "cache_enabled?",
        "cache_logging","cache_logging=","cache_logging?","cache_logging_level","cache_logging_level=","cache_logging_level?",
        "cache_page_extension","cache_page_extension=","cache_page_extension?"
      ].each do |m|
        
        it "the :#{m} method" do 
          assert_respond_to(Sinatra::Default, m.to_sym)
        end
        
      end
      
    end #/should respond to
    
  end #/Sinatra::Default
  
end #/Sinatra::Cache