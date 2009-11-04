
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/spec_helper"

describe "Sinatra" do 
  
  describe "Cache" do 
    
    class MyDefaultsTestApp < MyTestApp
      register(Sinatra::Cache)
    end
    
    
    class MyTestApp
      register(Sinatra::Cache)
      
      set :cache_enabled, true
      set :cache_environment, :test
      set :cache_output_dir, "#{public_fixtures_path}/system/cache"
      set :cache_fragments_output_dir, "#{public_fixtures_path}/system/cache/fragments"
      
      get '/' do 
        erb(:index)
      end
      
      get '/erb' do 
        erb(:index, :layout => false) #, :cache => false)
      end
      
      get '/haml' do 
        haml(:index)
      end
      get %r{/params/?([\s\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?} do
        @captures = params[:captures].nil? ? [] : params[:captures].compact
        erb(:params)
      end
      get '/css/screen.css' do 
        content_type 'text/css'
        sass(:css, :style => :compact)
      end
      get '/css/no/cache.css' do 
        content_type 'text/css'
        sass(:css, :style => :compact, :cache => false)
      end
      
      get '/fragments' do 
        erb(:fragments, :layout => false, :cache => false)
      end
      
      # get '/output' do
      #   @var = OpenStruct.new( :name => "Steve Jobs", :company => "Apple Inc." )
      # end
      
    end
    
    
    it_should_behave_like "MyTestApp"
    
    # it_should_behave_like "debug => app.methods"
    
    describe "#self.version" do 
      
      it "should return a version of the Sinatra::Cache VERSION string" do 
        Sinatra::Cache.version.should be_a_kind_of(String)
        Sinatra::Cache.version.should match(/Sinatra::Cache v\d\.\d+\.\d+(\.\d)?/)
      end
      
    end #/ #self.version
    
    describe "Default configurations options" do 
      
      describe ":cache_enabled" do 
        
        it "should be set to false" do 
          MyDefaultsTestApp.cache_enabled.should == false
        end
        
      end #/ :cache_enabled
      
      describe ":cache_environment" do 
        
        it "should be set to :production" do 
          MyDefaultsTestApp.cache_environment.should == :production
        end
        
      end #/ :cache_environment
      
      describe ":cache_page_extension" do 
        
        it "should be set to '.html'" do 
          MyDefaultsTestApp.cache_page_extension.should == '.html'
        end
        
      end #/ :cache_page_extension
      
      describe ":cache_output_dir" do 
        
        it "should be set to '' [empty]" do 
          MyDefaultsTestApp.cache_output_dir.should == ''
        end
        
      end #/ :cache_output_dir
      
      describe ":cache_fragments_output_dir" do 
        
        it "should be set to '/cache_fragments'" do 
          MyDefaultsTestApp.cache_fragments_output_dir.should == '/cache_fragments'
        end
        
      end #/ :cache_fragments_output_dir
      
      describe ":cache_logging" do 
        
        it "should be set to true" do 
          MyDefaultsTestApp.cache_logging.should == true
        end
        
      end #/ :cache_logging
      
      describe ":cache_logging_level" do 
        
        it "should be set to :info" do 
          MyDefaultsTestApp.cache_logging_level.should == :info
        end
        
      end #/ :cache_logging_level
      
    end #/ Default configurations options
    
    describe "Custom configurations options" do 
      
      describe ":cache_enabled" do 
        
        it "should be set to true" do 
          MyTestApp.cache_enabled.should == true
        end
        
      end #/ :cache_enabled
      
      describe ":cache_environment" do 
        
        it "should be set to :test" do 
          MyTestApp.cache_environment.should == :test
        end
        
      end #/ :cache_environment
      
      describe ":cache_page_extension" do 
        
        it "should be set to '.html'" do 
          MyTestApp.cache_page_extension.should == '.html'
        end
        
      end #/ :cache_page_extension
      
      describe ":cache_output_dir" do 
        
        it "should be set to '../public/system/cache'" do 
          MyTestApp.cache_output_dir.should == "#{public_fixtures_path}/system/cache"
        end
        
      end #/ :cache_output_dir
      
      describe ":cache_fragments_output_dir" do 
        
        it "should be set to '../public/system/cache/fragments'" do 
          MyTestApp.cache_fragments_output_dir.should == "#{public_fixtures_path}/system/cache/fragments"
        end
        
      end #/ :cache_fragments_output_dir
      
      describe ":cache_logging" do 
        
        it "should be set to true" do 
          MyTestApp.cache_logging.should == true
        end
        
      end #/ :cache_logging
      
      describe ":cache_logging_level" do 
        
        it "should be set to :info" do 
          MyTestApp.cache_logging_level.should == :info
        end
        
      end #/ :cache_logging_level
      
    end #/ Custom configurations options
    
    describe "with caching enabled" do 
      
      describe "basic Page caching" do 
        
        describe "GET '/' - index.html (with layout)" do 
          
          before(:each) do 
            @cache_file = "#{public_fixtures_path}/system/cache/index.html"
            get('/')
          end
          
          after(:each) do
            # FileUtils.rm(@cache_file)
          end
          
          it "should work as normal" do 
            body.should have_tag('html > head > title', 'Sinatra::Cache') 
            body.should match(/<!-- page cached: \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -->/)
            body.should have_tag('html > body > h1', 'HOME')
          end
          
          it "should create a cached file in the cache output directory" do
            test(?f, @cache_file).should == true
          end
          
        end #/ GET '/' - index.html
        
        describe "GET '/erb' - erb.html" do 
          
          before(:each) do 
            @cache_file = "#{public_fixtures_path}/system/cache/erb.html"
            get('/erb')
          end
          
          after(:each) do
            # FileUtils.rm(@cache_file)
          end
          
          it "should work as normal" do 
            body.should == "<h1>HOME</h1>"
          end
          
          it "should create a cached file in the cache output directory" do
            test(?f, @cache_file).should == true
          end
          
        end #/ GET '/erb' - erb.html
        
        describe "GET '/haml' - haml.html" do 
          
          before(:each) do 
            @cache_file = "#{public_fixtures_path}/system/cache/haml.html"
            get('/haml')
          end
          
          after(:each) do
            # FileUtils.rm(@cache_file)
          end
          
          it "should work as normal" do 
            body.should == "<h1>HOME</h1>"
          end
          
          it "should create a cached file in the cache output directory" do
            test(?f, @cache_file).should == true
          end
          
        end #/ GET '/haml' - haml.html
        
        # describe "GET '/output.EXT  - " do 
        #   
        #   it "should description" do 
        #     get('/output.xml') 
        #     
        #     body.should == ''
        #   end
        #   
        # end #/ GET '/output.EXT
        
      end #/ basic Page caching
      
      # describe "caching with URL query strings [ /?page=2 ]" do 
      #   
      #   it "should completely ignore the URL queries in the cached file path" do 
      #     
      #   end
      #   
      #   it "should overwrite the " do
      #     
      #   end
      #   
      # end #/ caching with URL query strings [ /products/?page=2 ]
      # 
      
      # describe "fragment caching" do 
      #   
      #   it "should cache fragments" do 
      #     get('/fragments')
      #     
      #     body.should == 'sdafadf'
      #   end
      #   
      # end #/ fragment caching
      
      
      describe "caching with URL params" do 
        
        # %w(/params/? /params/page/?page=2 /params/page/?page=99 /params/a/  /params/a/b /params/a/b/c /params/a/b/c/d ).each do |url|
        %w(/params/? /params/a/  /params/a/b /params/a/b/c /params/a/b/c/d ).each do |url|
          
          file_url = (url[-1,1] =~ /\/|\?/) ? "#{url.chomp('?')}index" : url
          
          describe "GET '#{url}' - #{file_url}" do 
            
            before(:each) do 
              # FileUtils.remove_dir("#{public_fixtures_path}/system/cache/params")
              # FileUtils.rm("#{public_fixtures_path}/system/cache/params.html")
              # file_url = (url[-1,1] =~ /\/|\?/) ? "#{url.chomp('?')}index" : url
              @cache_file = "#{public_fixtures_path}/system/cache#{file_url}.html"
              get(url)
            end
            
            after(:each) do 
              # FileUtils.remove_dir("#{public_fixtures_path}/system/cache/params")
            end
            
            it "should work as normal" do 
              body.should have_tag('html > head > title', 'Sinatra::Cache') 
              body.should have_tag('html > body > h1', 'PARAMS')
              body.should have_tag('p')
            end
            
            it "should create a cached file in the cache output directory" do 
              test(?f, @cache_file).should == true
            end
            
          end #/ GET 'url' - 
          
        end #/ end loop
        
      end #/ caching with URL params
      
      describe "caching .sass files" do 
        
        describe "using defaults" do 
          
          describe "GET '/css/screen.css' - /css/screen.css" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/css/screen.css"
              FileUtils.remove_dir(File.dirname(@cache_file), :force => true )
              get('/css/screen.css')
            end
            
            after(:each) do 
              # FileUtils.rm(@cache_file)
              # FileUtils.remove_dir(File.dirname(@cache_file), :force => true )
            end
            
            it "should work as normal" do 
              body.should == "body { color: red; }"
            end
            
            it "should automatically create the cache /css output directory" do
              test(?d, File.dirname(@cache_file) ).should == true
            end
            
            it "should create a cached file in the cache output directory" do
              test(?f, @cache_file).should == true
            end
            
          end #/ GET '/css/screen.css' - /css/screen.css
          
          
        end #/ using defaults
        
        describe "with :cache => false" do 
          
          describe "GET '/css/no/cache.css' - /css/no/cache.css" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/css/no/cache.css"
              get('/css/no/cache.css')
            end
            
            after(:each) do
              # FileUtils.rm(@cache_file)
            end
            
            it "should work as normal (adds extra '\\n' chars to the output)" do 
              body.should == "body { color: red; }\n"
            end
            
            it "should NOT automatically create the cache /css/no output directory" do
              test(?d, File.dirname(@cache_file) ).should == false
            end
            
            it "should NOT create a cached file in the cache output directory" do
              test(?f, @cache_file).should == false
            end
            
          end #/ GET '/css/no/cache.css' - /css/no/cache.css
          
        end #/ with :cache => false
        
      end #/ caching .sass files
      
    end #/ with caching enabled
    
  end #/ Cache
  
  
  describe "Templates" do 
    
    
  end #/Templates
  
  
end #/ Sinatra
