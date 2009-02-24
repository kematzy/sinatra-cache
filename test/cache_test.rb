require File.dirname(__FILE__) + '/helper'
require '../lib/sinatra/cache'

class Sinatra::Base
  # include Sinatra::Cache
end #/class Sinatra::Base

describe "Sinatra::Cache" do 
  
  before(:each) do
    
    default_app = mock_app do 
      register Sinatra::Cache
      
      set :public, "#{File.dirname(__FILE__)}/fixtures/public"
      set :views, "#{File.dirname(__FILE__)}/fixtures/views"
      
      get '/' do
        erb(:index)
      end
      
      get '/cache' do
        # "Hello World from Sinatra Version=[#{Sinatra::VERSION}]"
        cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
      end
      
    end
    
    custom_app = mock_app do
      register Sinatra::Cache
      
      set :public, "#{File.dirname(__FILE__)}/fixtures/public"
      set :views, "#{File.dirname(__FILE__)}/fixtures/views"
      
      set :cache_enabled, false
      set :cache_page_extension, '.cache.html'
      set :cache_dir, 'system/cache'
      set :cache_logging, false
      set :cache_logging_level, :info
      
      get '/' do
        erb :index
      end
      
      get '/cache' do
        cache("Hello World from Sinatra Version=[#{Sinatra::VERSION}]")
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
  end #/Instance Methods
  
  
  describe "configuration methods" do 
    
    describe "when using default options" do 
      
      it "the :cache_enabled option should be correct (true)" do 
        assert_equal(true, @default_app.options.cache_enabled)
      end
      
      it "the :cache_page_extension option should be correct (.html)" do 
        assert_equal('.html', @default_app.options.cache_page_extension)
      end
      
      it "the :cache_dir option should be correct ('') " do 
        assert_equal('', @default_app.options.cache_dir)
      end
      
      it "the :cache_logging option should be correct (true)" do 
        assert_equal(true, @default_app.options.cache_logging)
      end
      
      it "the :cache_logging_level option should be correct (:debug)" do 
        assert_equal(:debug, @default_app.options.cache_logging_level)
      end
      
    end #/default options
    
    describe "when using customized options" do 
      
      it "the :cache_enabled option should be correct (false)" do 
        assert_equal(false, @custom_app.options.cache_enabled)
      end
      
      it "the :cache_page_extension option should be correct (.cache.html)" do 
        assert_equal('.cache.html', @custom_app.options.cache_page_extension)
      end
      
      it "the :cache_dir option should be correct ('system/cache') " do 
        assert_equal('system/cache', @custom_app.options.cache_dir)
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
    
    it "should description" do 
      request = Rack::MockRequest.new(@default_app)
      response = request.get('/')
      
      # assert_equal '', response.inspect
      # assert_equal '', response.body
    end
    
    describe "when using default options" do 
      
      # it "should create a cached page with the right name in the correct location" do 
      #   request = Rack::MockRequest.new(@default_app)
      #   response = request.get('/cache')
      #   # assert response #inspect
      #   # assert_equal '', response.body
      #   
      # end
      
    end #/when using default options
  end #/Page Caching
  
  
  describe "Sinatra::Base" do 
    
    before do
      Sinatra::Base.register(Sinatra::Cache)
    end
    
    describe "should respond to" do 
      
      [
        "cache_dir", "cache_dir=","cache_dir?", "cache_enabled","cache_enabled=", "cache_enabled?",
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
        "cache_dir", "cache_dir=","cache_dir?", "cache_enabled","cache_enabled=", "cache_enabled?",
        "cache_logging","cache_logging=","cache_logging?","cache_logging_level","cache_logging_level=","cache_logging_level?",
        "cache_page_extension","cache_page_extension=","cache_page_extension?"
      ].each do |m|
        
        it "the :#{m} method" do 
          assert_respond_to(Sinatra::Default, m.to_sym)
        end
        
      end
      
    end #/should respond to
    
  end #/Sinatra::Default
  
  # it "should description" do 
  #   assert_equal('Sinatra::Application', Sinatra::Application.methods.sort)
  # end
  # it "should description1" do 
  #   assert_equal('Sinatra::Base', Sinatra::Base.methods.sort)
  # end
  # it "should description2" do 
  #   assert_equal('@default_app', @default_app.methods.sort)
  # end
  # 
  # it "should description3" do 
  #   assert_equal('Sinatra::Default', Sinatra::Default.methods.sort)
  # end
  
  
  
end #/Sinatra::Cache