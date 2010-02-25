
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/spec_helper"

describe "Sinatra" do 
  
  before(:each) do 
    @delete_cached_test_files = true #convenience toggle
  end
  describe "Cache" do 
    
    class MyDefaultsTestApp < MyTestApp
      register(Sinatra::Cache)
    end
    
    
    class MyTestApp 
      register(Sinatra::Cache)
      
      # need to set the root of the app for the default :cache_fragments_output_dir to work
      set :root, ::APP_ROOT
      
      set :cache_enabled, true
      set :cache_environment, :test
      set :cache_output_dir, "#{public_fixtures_path}/system/cache"
      set :cache_fragments_output_dir, "#{public_fixtures_path}/system/cache_fragments"
      
      get('/') { erb(:index) }
      get('/erb/?') { erb(:index, :layout => false) }
      
      # complex regex URL, matches
      get %r{^/params/?([\s\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?} do
        @captures = params[:captures].nil? ? [] : params[:captures].compact
        erb(:params)
      end
      get('/file-extensions.*') do 
        @vars = { :framework => "Sinatra", :url => "www.sinatrarb.com" }
        case params[:splat].first.to_sym
        when :json
          erb(@vars.to_json, :layout => false )
        when :yaml
          erb(@vars.to_yaml,:layout => false) 
        else
          # direct output, should NOT be Cached
          @vars.inspect
          # @vars.inspect
        end
      end
      
      get '/css/screen.css' do 
        content_type 'text/css'
        sass(:css, :style => :compact)
      end
      get '/css/no/cache.css' do 
        content_type 'text/css'
        sass(:css, :style => :compact, :cache => false)
      end
      
      # enable :method_override
      post('/post/?') { erb("POST", :layout => false) }
      put('/put/?') { erb('PUT', :layout => false) }
      delete('/delete/?') { erb('DELETE', :layout => false) }
      
      get %r{^/fragments/?([\s\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?} do
        erb(:fragments, :layout => false, :cache => false) 
      end
      get %r{^/sharedfragments/?([\s\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?} do
        erb(:fragments_shared, :layout => false, :cache => false) 
      end
      
      
    end
    
    
    it_should_behave_like "MyTestApp"
    
    # it_should_behave_like "debug => app.methods"
    
    describe "VERSION" do 
      
      it "should return the VERSION string" do 
        Sinatra::Cache::VERSION.should be_a_kind_of(String)
        Sinatra::Cache::VERSION.should match(/\d\.\d+\.\d+(\.\d)?/)
      end
      
    end #/ VERSION
    
    describe "#self.version" do 
      
      it "should return a version of the Sinatra::Cache VERSION string" do 
        Sinatra::Cache.version.should be_a_kind_of(String)
        Sinatra::Cache.version.should match(/Sinatra::Cache v\d\.\d+\.\d+(\.\d)?/)
      end
      
    end #/ #self.version
    
    
    describe "Configuration" do 
      
      describe "with Default Settings" do 
        
        it "should set :cache_enabled to false" do 
          MyDefaultsTestApp.cache_enabled.should == false
        end
        
        it "should set :cache_environment to :production" do 
          MyDefaultsTestApp.cache_environment.should == :production
        end
        
        it "should set :cache_page_extension to '.html'" do 
          MyDefaultsTestApp.cache_page_extension.should == '.html'
        end
        
        it "should set :cache_output_dir to '' [empty]" do 
          MyDefaultsTestApp.cache_output_dir.should == ''
        end
        
        it "should set :cache_fragments_output_dir to '../tmp/cache_fragments'" do 
          MyDefaultsTestApp.cache_fragments_output_dir.should == "#{fixtures_path}/tmp/cache_fragments"
        end
        
        it "should set :cache_logging to true" do 
          MyDefaultsTestApp.cache_logging.should == true
        end
        
        it "should set :cache_logging_level to :info" do 
          MyDefaultsTestApp.cache_logging_level.should == :info
        end
        
      end #/ with Default Settings
      
      describe "with Custom Settings" do 
        
        it "should set :cache_enabled to true" do 
          MyTestApp.cache_enabled.should == true
        end
        
        it "should set :cache_environment to :test" do 
          MyTestApp.cache_environment.should == :test
        end
        
        it "should set :cache_page_extension to '.html'" do 
          MyTestApp.cache_page_extension.should == '.html'
        end
        
        it "should set :cache_output_dir to '../public/system/cache'" do 
          MyTestApp.cache_output_dir.should == "#{public_fixtures_path}/system/cache"
        end
        
        it "should set :cache_fragments_output_dir to '../public/system/cache_fragments'" do 
          MyTestApp.cache_fragments_output_dir.should == "#{public_fixtures_path}/system/cache_fragments"
        end
        
        it "should set :cache_logging to true" do 
          MyTestApp.cache_logging.should == true
        end
        
        it "should set :cache_logging_level to :info" do 
          MyTestApp.cache_logging_level.should == :info
        end
        
      end #/ Custom
      
    end #/ Configuration
    
    
    describe "Helpers" do 
      
      describe "#cache_timestamp" do 
        
        it "should return an HTML comment with the current timestamp" do 
          erb_app "<%= cache_timestamp %>"
          body.should match(/\<\!-- page cached\: #{Regexp.escape(Time.now.strftime("%Y-%m-%d %H:%M:%S"))} -->/)
        end
        
      end #/ #cache_timestamp
      
      module Sinatra::Cache::Helpers
        public :cache_file_path, :cache_write_file, :cache_file_name, :cache_page_path
      end
      
      describe "#cache_file_path" do 
        
        it "should have some tests"
        
      end #/ #cache_file_path
      
      describe "#cache_write_file" do 
        
        it "should have some tests"
        
      end #/ #cache_write_file
      
      describe "#cache_file_name" do 
        
        it "should have some tests"
        
      end #/ #cache_file_name
      
      describe "#cache_page_path" do 
        
        it "should have some tests"
        
      end #/ #cache_page_path
      
    end #/ Helpers
    
    
    describe "with caching enabled" do 
      
      describe "basic Page caching" do 
        
        describe "GET requests for" do 
          
          describe "the Home page - ['/' => /index.html] (with layout)" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/index.html"
              get('/')
            end
            
            after(:each) do
              FileUtils.rm(@cache_file) if @delete_cached_test_files
            end
            
            it "should render the expected output" do 
              body.should have_tag('html > head > title', 'Sinatra::Cache') 
              body.should match(/<!-- page cached: #{Regexp.escape(Time.now.strftime("%Y-%m-%d %H:%M:%S"))} -->/)
              body.should have_tag('html > body > h1', 'HOME')
            end
            
            it "should create a cached file in the cache output directory" do 
              test(?f, @cache_file).should == true
            end
            
          end #/ GET ['/' => /index.html]
          
          describe "a basic URL without a trailing slash - ['/erb' => /erb.html] (ERB without layout)" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/erb.html"
              get('/erb')
            end
            
            after(:each) do 
              FileUtils.rm(@cache_file) if @delete_cached_test_files
            end
            
            it "should render the expected output" do 
              body.should == "<h1>HOME</h1>"
            end
            
            it "should create a cached file in the cache output directory" do 
              test(?f, @cache_file).should == true
            end
            
          end #/ GET ['/erb' => /erb.html]
          
          describe "a basic URL with a trailing slash - ['/erb/' => /erb/index.html]" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/erb/index.html"
              get('/erb/')
            end
            
            after(:each) do 
              FileUtils.rm(@cache_file) if @delete_cached_test_files
            end
            
            it "should render the expected output" do 
              body.should == "<h1>HOME</h1>"
            end
            
            it "should create a cached file at ../cache/< URL >/index.html" do
              test(?f, @cache_file).should == true
            end
            
          end #/ GET ['/erb/' => /erb/index.html]
          
          describe "a URL with file extension - ['/file-extensions.EXT' => /file-extensions.EXT]" do 
            
            before(:each) do 
              ext =  '.yaml'
              @cache_file = "#{public_fixtures_path}/system/cache/file-extensions#{ext}"
              get("/file-extensions#{ext}") 
            end
            
            after(:each) do 
              FileUtils.rm(@cache_file) if @delete_cached_test_files
            end
            
            it "should render the expected output" do 
              body.should_not == ""
            end
            
            it "should create the cached file with the extension" do 
              test(?f, @cache_file).should == true
            end
            
          end #/ GET ['/file-extensions.EXT' => /file-extensions.EXT]
          
          describe "URLs with multiple levels and/or with ?params attached" do 
            
            %w(
              /params/? /params/1.xml?p=2 /params/page/?page=2 /params/page/?page=99 
              /params/a/  /params/a/b /params/a/b/c /params/a/b/c/d 
            ).each do |url| 
              
              # does the URL contain a ? or not
              params_free_url = url =~ /\?/ ? url.split('?').first.chomp('?') : url
              file_url = (params_free_url[-1,1] =~ /\//) ? "#{params_free_url}index" : params_free_url
              
              # create the string for the test output below
              file_url_str = File.extname(file_url) == '' ? file_url << '.html' : file_url 
              
              describe "the URL ['#{url}' => #{file_url_str}]" do 
                
                before(:each) do 
                  @file_url = file_url
                  @cache_file = "#{public_fixtures_path}/system/cache#{file_url}"
                  @cache_file << ".html" if File.extname(@file_url) == '' 
                  # puts "when the URL=[#{url}] the @cache_file=[#{@cache_file}] [#{__FILE__}:#{__LINE__}]"
                  get(url)
                end
                
                after(:each) do 
                  FileUtils.remove_dir("#{public_fixtures_path}/system/cache/params") if @delete_cached_test_files
                end
                
                it "should render the expected output" do 
                  body.should have_tag('html > head > title', 'Sinatra::Cache') 
                  body.should have_tag('html > body > h1', 'PARAMS')
                  body.should have_tag('html > body > p' )
                end
                
                it "should create a cached file at [../public/system/cache#{file_url_str}]" do 
                  test(?f, @cache_file).should == true
                end
                
              end #/ GET 'url' - 
              
            end #/ end loop
            
          end #/ URLs with multiple levels and/or with ?params attached
          
          describe "CSS URLs with dynamic .sass files" do 
            
            describe "the URL ['/css/screen.css' => /css/screen.css]" do 
              
              before(:each) do 
                @cache_file = "#{public_fixtures_path}/system/cache/css/screen.css"
                FileUtils.remove_dir(File.dirname(@cache_file), :force => true )
                get('/css/screen.css')
              end
              
              after(:each) do 
                FileUtils.rm(@cache_file) if @delete_cached_test_files
                FileUtils.remove_dir(File.dirname(@cache_file), :force => true ) if @delete_cached_test_files
              end
              
              it "should output the correct CSS as expected" do 
                body.should == "body { color: red; }"
              end
              
              it "should automatically create the cache /css output directory" do 
                test(?d, File.dirname(@cache_file) ).should == true
              end
              
              it "should create a cached file at [../public/system/cache/css/screen.css]" do 
                test(?f, @cache_file).should == true
              end
              
            end #/ GET ['/css/screen.css' => /css/screen.css]
            
            describe "URLs with ':cache => false' - ['/css/no/cache.css' => /css/no/cache.css]" do 
              
              before(:each) do 
                @cache_file = "#{public_fixtures_path}/system/cache/css/no/cache.css"
                get('/css/no/cache.css')
              end
              
              it "should output the correct CSS as expected" do 
                body.should == "body { color: red; }\n"
              end
              
              it "should NOT cache the output" do 
                test(?d, File.dirname(@cache_file) ).should == false  # testing for directory
                test(?f, @cache_file).should == false
              end
              
            end #/ GET ['/css/no/cache.css' => /css/no/cache.css]
            
          end #/ CSS URLs with dynamic .sass files
          
        end #/ GET requests
        
        describe "POST, PUT, DELETE requests" do 
          
          describe "POST '/post'" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/post.html"
              post('/post', :test => {:name => "test-#{Time.now.strftime("%Y-%d-%m %H:%M:%S")}", :content => "with content" })
            end
            
            it "should render any output as normal" do 
              body.should == 'POST'
            end
            
            it "should NOT cache the output" do
              test(?f, @cache_file).should == false
            end
            
          end #/ POST '/post'
          
          describe "PUT '/put'" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/put.html"
              put('/put', { :test => { :name => "test" }, :_method => "put" })
            end
            
            it "should render any output as normal" do 
              body.should == 'PUT'
            end
            
            it "should NOT cache the output" do
              test(?f, @cache_file).should == false
            end
            
          end #/ PUT '/put'
          
          describe "DELETE '/delete'" do 
            
            before(:each) do 
              @cache_file = "#{public_fixtures_path}/system/cache/delete.html"
              delete('/delete') #, { :test => { :name => "test" }, :_method => "put" })
            end
            
            it "should render any output as normal" do 
              body.should == 'DELETE'
            end
            
            it "should NOT cache the output" do
              test(?f, @cache_file).should == false
            end
            
          end #/ DELETE '/delete'
          
        end #/ POST, PUT, DELETE requests
        
      end #/ basic Page caching
      
      describe "and Fragment caching" do 
        
        describe "using NOT shared fragments" do 
          
          after(:all) do
            FileUtils.rm_r("#{public_fixtures_path}/system/cache_fragments/fragments") if @delete_cached_test_files
          end
          
          %w(
            /fragments /fragments/a/b/ /fragments/with/param/?page=1 
            /fragments/dasherised-urls/works-as-well
          ).each do |url|
            
            params_free_url = url =~ /\?/ ? url.split('?').first.chomp('?') : url
            dir_structure = params_free_url.gsub(/^\//,'').gsub(/\/$/,'')
            
            it "should cache the fragments from the URL [#{url}] as [#{dir_structure}/test_fragment.html]" do
              get(url)
              # body.should have_tag(:debug)
              body.should have_tag('h1','FRAGMENTS', :count => 1)
              body.should_not match(/<!-- cache fragment:(.+)test_fragment -->/)
              body.should_not match(/<!-- \/cache fragment: test_fragment cached at \[ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\] -->/)
              
              # render the page a 2nd time from cache
              get(url)
              body.should have_tag('h1','FRAGMENTS', :count => 1)
              body.should match(/<!-- cache fragment:(.+)test_fragment -->/)
              body.should match(/<!-- \/cache fragment: test_fragment cached at \[ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\] -->/)
              
              # the cached fragment has already been found if we get this far, 
              # but just for good measure do we check for the existence of the fragment file.
              test(?f, "#{public_fixtures_path}/system/cache_fragments/#{dir_structure}/test_fragment.html").should == true
            end
          end
          
        end #/ using NOT shared fragments
        
        describe "using shared fragments" do 
          
          after(:all) do
            FileUtils.rm_r("#{public_fixtures_path}/system/cache_fragments/sharedfragments") if @delete_cached_test_files
          end
          
          describe "when requesting the first URL" do 
            
            #  FIXME:: work out some clever way to split all of these tests into single items instead of in one big blob
             
            it "should cache the fragment based on the URL and use it on subsequent requests by URLs sharing the same root URL" do
              url = '/sharedfragments/2010/02/some-article-01'
              params_free_url = url =~ /\?/ ? url.split('?').first.chomp('?') : url
              dir_structure = params_free_url.gsub(/^\//,'').gsub(/\/$/,'')
              dirs = dir_structure.split('/')
              dir_structure = dirs.first(dirs.length-1).join('/')
              
              get(url)
              # body.should have_tag(:debug)
              body.should have_tag('h1','FRAGMENTS - SHARED', :count => 1)
              body.should_not match(/<!-- cache fragment:(.+)test_fragment -->/)
              body.should_not match(/<!-- \/cache fragment: test_fragment cached at \[ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\] -->/)
              
              get(url)
              body.should have_tag('h1','FRAGMENTS - SHARED', :count => 1)
              body.should match(/<!-- cache fragment:(.+)test_fragment -->/)
              body.should match(/<!-- \/cache fragment: test_fragment cached at \[ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\] -->/)
              
              # the cached fragment has already been found if we get this far, 
              # but just for good measure do we check for the existence of the fragment file.
              test(?f, "#{public_fixtures_path}/system/cache_fragments/#{dir_structure}/test_fragment.html").should == true
              
              # should use the cached fragment rather than cache a new fragment
              url = '/sharedfragments/2010/02/another-article-02'
              get(url)
              body.should have_tag('h1','FRAGMENTS - SHARED', :count => 1)
              body.should match(/<!-- cache fragment:(.+)test_fragment -->/)
              body.should match(/<!-- \/cache fragment: test_fragment cached at \[ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\] -->/)
            end
            
          end #/ when requesting the first URL
          
        end #/ using shared fragments
        
      end #/ and Fragment caching
      
      describe "basic Cache Expiring" do 
        
        describe "Pages" do 
          
          it "should expire the page ['/params/cache/expire/' => ../cache/params/cache/expire/index.html]" do 
            get('/params/cache/expire/')
            test(?f,"#{public_fixtures_path}/system/cache/params/cache/expire/index.html" ).should == true
            lambda { 
              erb_app "<% cache_expire('/params/cache/expire/') %>"
            }.should_not raise_error(Exception)
            
            test(?f,"#{public_fixtures_path}/system/cache/params/cache/expire/index.html" ).should == false
            
          end
          
          it "should expire the page ['/params/cache/expired' => ../cache/params/cache/expired.html]" do 
            get('/params/cache/expired')
            test(?f,"#{public_fixtures_path}/system/cache/params/cache/expired.html" ).should == true
            lambda { 
              erb_app "<% cache_expire('/params/cache/expired') %>"
            }.should_not raise_error(Exception)
            
            test(?f,"#{public_fixtures_path}/system/cache/params/cache/expired.html" ).should == false
            
          end
          
        end #/ Pages
        
        describe "Fragments" do 
          
          it "should expire the fragment ['/fragments/cache/expire/' => ../cache_fragments/fragments/cache/expire/test_fragment.html]" do 
            get('/fragments/cache/expire/')
            test(?f,"#{public_fixtures_path}/system/cache_fragments/fragments/cache/expire/test_fragment.html" ).should == true
            lambda { 
              erb_app "<% cache_expire('/fragments/cache/expire/',:fragment => :test_fragment) %>"
            }.should_not raise_error(Exception)
            test(?f,"#{public_fixtures_path}/system/cache/params/cache_fragments/expire/test_fragment.html" ).should == false
          end
          
          it "should expire the fragment ['/fragments/cache/expired' => ../cache_fragments/fragments/cache/expired/test_fragment.html]" do 
            get('/fragments/cache/expired')
            test(?f,"#{public_fixtures_path}/system/cache_fragments/fragments/cache/expired/test_fragment.html" ).should == true
            lambda { 
              erb_app "<% cache_expire('/fragments/cache/expired',:fragment => :test_fragment) %>"
            }.should_not raise_error(Exception)
            test(?f,"#{public_fixtures_path}/system/cache/params/cache_fragments/expired/test_fragment.html" ).should == false
          end
          
        end #/ Pages
        
      end #/ basic Cache Expiring
      
      
    end #/ with caching enabled
    
  end #/ Cache
  
end #/ Sinatra
