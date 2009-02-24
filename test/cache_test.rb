require File.dirname(__FILE__) + '/helper'
require 'sinatra/cache'

class Sinatra::Base
  # include Sinatra::Cache
end #/class Sinatra::Base

describe "Sinatra::Cache" do 
  
  before(:each) do
    
    @default_app = mock_app do 
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
    
    @custom_app = mock_app do
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
        
        class Sinatra::Base
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

        class Sinatra::Base
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
      
    end #/Private
  end #/Instance Methods
  
  
  describe "configuration methods" do 
    
    # before(:each) do
    #   @default_app = mock_app { 
    #     register Sinatra::Cache
    #     
    #     get '/' do
    #       'foo'
    #     end
    #      
    #   }
    #   
    #   @custom_app = mock_app { 
    #     register Sinatra::Cache
    #     
    #     set :cache_enabled, false
    #     set :cache_page_extension, '.cache.html'
    #     set :cache_dir, 'system/cache'
    #     set :cache_logging, false
    #     set :cache_logging_level, :info
    #   }
    # end
    
    describe "when using default options" do 
      
      it "the :cache_enabled option should be correct (true)" do 
        assert_equal(true, @default_app.cache_enabled)
      end
      
      it "the :cache_page_extension option should be correct (.html)" do 
        assert_equal('.html', @default_app.cache_page_extension)
      end
      
      it "the :cache_dir option should be correct ('') " do 
        assert_equal('', @default_app.cache_dir)
      end
      
      it "the :cache_logging option should be correct (true)" do 
        assert_equal(true, @default_app.cache_logging)
      end
      
      it "the :cache_logging_level option should be correct (:debug)" do 
        assert_equal(:debug, @default_app.cache_logging_level)
      end
      
    end #/default options
    
    # describe "when using customized options" do 
    #   
    #   it "the :cache_enabled option should be correct (false)" do 
    #     assert_equal(false, @custom_app.cache_enabled)
    #   end
    #   
    #   it "the :cache_page_extension option should be correct (.cache.html)" do 
    #     assert_equal('.cache.html', @custom_app.cache_page_extension)
    #   end
    #   
    #   it "the :cache_dir option should be correct ('system/cache') " do 
    #     assert_equal('system/cache', @custom_app.cache_dir)
    #   end
    #   
    #   it "the :cache_logging option should be correct (true)" do 
    #     assert_equal(false, @custom_app.cache_logging)
    #   end
    #   
    #   it "the :cache_logging_level option should be correct (:info)" do 
    #     assert_equal(:info, @custom_app.cache_logging_level)
    #   end
    #   
    # end #/when using customized options
    
  end #/configuration methods
  
  
  describe "Page Caching" do 
    
    it "should description" do 
      request = Rack::MockRequest.new(@default_app)
      response = request.get('/')
      assert response #inspect
      assert_equal '', response.body
    end
    
    describe "when using default options" do 
      
      it "should create a cached page with the right name in the correct location" do 
        request = Rack::MockRequest.new(@default_app)
        response = request.get('/cache')
        # assert response #inspect
        assert_equal '', response.body
        
      end
      
    end #/when using default options
  end #/Page Caching
  
  
  
  
  describe "Sinatra::Base" do 
    
    before do
      Sinatra::Base.register(Sinatra::Cache)
    end
    
    it "should respond to" do 
      assert(Sinatra::Base.respond_to?(:cache_enabled))
      assert(Sinatra::Base.respond_to?(:cache_page_extension))
      assert(Sinatra::Base.respond_to?(:cache_dir))
      assert(Sinatra::Base.respond_to?(:cache_logging))
      assert(Sinatra::Base.respond_to?(:cache_logging_level))
      assert(Sinatra::Base.respond_to?(:cache))
      assert(Sinatra::Base.respond_to?(:cache_expire))
    end
    
  end #/Sinatra::Base
  
  describe "Sinatra::Default" do 
    
    before do
      Sinatra::Base.register(Sinatra::Cache)
    end
    
    it "should respond to" do 
      assert(Sinatra::Default.respond_to?(:cache_enabled))
      assert(Sinatra::Default.respond_to?(:cache_page_extension))
      assert(Sinatra::Default.respond_to?(:cache_dir))
      assert(Sinatra::Default.respond_to?(:cache_logging))
      assert(Sinatra::Default.respond_to?(:cache_logging_level))
      assert(Sinatra::Default.respond_to?(:cache))
      assert(Sinatra::Default.respond_to?(:cache_expire))
    end
    
  end #/Sinatra::Default
  
  
end #/Sinatra::Cache