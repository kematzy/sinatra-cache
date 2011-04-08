
module Sinatra 
  
  # = Sinatra::Cache
  # 
  # A Sinatra Extension that makes Page and Fragment Caching easy wthin your Sinatra apps.
  # 
  # == Installation
  # 
  #   #  Add RubyGems.org (former Gemcutter) to your RubyGems sources 
  #   $  gem sources -a http://rubygems.org
  # 
  #   $  (sudo)? gem install sinatra-cache
  # 
  # == Dependencies
  # 
  # This Gem depends upon the following:
  # 
  # === Runtime:
  # 
  # * sinatra ( >= 1.0.a )
  # * sinatra-outputbuffer[http://github.com/kematzy/sinatra-outputbuffer] (>= 0.1.0)
  # 
  # Optionals:
  # 
  # * sinatra-settings[http://github.com/kematzy/sinatra-settings] (>= 0.1.1) # to view default settings in a browser display.
  # 
  # === Development & Tests:
  # 
  # * rspec (>= 1.3.0 )
  # * rack-test (>= 0.5.3)
  # * rspec_hpricot_matchers (>= 0.1.0)
  # * sinatra-tests (>= 0.1.6)
  # * fileutils
  # * sass
  # * ostruct
  # * yaml
  # * json
  # 
  # 
  # == Getting Started
  # 
  # To start caching your app's ouput, just require and register 
  # the extension in your sub-classed Sinatra app:
  # 
  #   require 'sinatra/cache'
  # 
  #   class YourApp < Sinatra::Base
  # 
  #     # NB! you need to set the root of the app first
  #     set :root, '/path/2/the/root/of/your/app'
  # 
  #     register(Sinatra::Cache)
  # 
  #     set :cache_enabled, true  # turn it on
  # 
  #     <snip...>
  # 
  #   end
  # 
  # 
  # That's more or less it. 
  # 
  # You should now be caching your output by default, in <tt>:production</tt> mode, as long as you use 
  # one of Sinatra's render methods:
  # 
  #   erb(),  erubis(), haml(), sass(), builder(), etc..
  # 
  # ...or any render method that uses <tt>Sinatra::Templates#render()</tt> as its base.
  # 
  # 
  # 
  # == Configuration Settings
  # 
  # The default settings should help you get moving quickly, and are fairly common sense based.
  # 
  # 
  # === <tt>:cache_enabled</tt>
  # 
  # This setting toggles the cache functionality On / Off. 
  # Default is: <tt>false</tt>
  # 
  # 
  # === <tt>:cache_environment</tt>
  # 
  # Sets the environment during which the cache functionality is active. 
  # Default is: <tt>:production</tt>
  # 
  # 
  # === <tt>:cache_page_extension</tt>+ 
  # 
  # Sets the default file extension for cached files. 
  # Default is: <tt>.html</tt>
  # 
  # 
  # === <tt>:cache_output_dir</tt>
  # 
  # Sets cache directory where the cached files are stored. 
  # Default is:  == "/path/2/your/app/public"
  # 
  # Although you can set it to the more ideal '<tt>..public/system/cache/</tt>' 
  # if you can get that to work with your webserver setup.
  # 
  # 
  # === <tt>:cache_fragments_output_dir</tt>
  # 
  # Sets the directory where cached fragments are stored. 
  # Default is the '../tmp/cache_fragments/' directory at the root of your app.
  # 
  # This is for security reasons since you don't really want your cached fragments publically available.
  # 
  # 
  # === <tt>:cache_fragments_wrap_with_html_comments</tt>
  # 
  # This setting toggles the wrapping of cached fragments in HTML comments. (see below)
  # Default is: <tt>true</tt>
  # 
  # 
  # === <tt>:cache_logging</tt>
  # 
  # This setting toggles the logging of various cache calls. If the app has access to the <tt>#logger</tt> method,
  # curtesy of Sinatra::Logger[http://github.com/kematzy/sinatra-logger] then it will log there, otherwise logging 
  # is silent.
  # 
  # Default is: <tt>true</tt>
  # 
  # 
  # === <tt>:cache_logging_level</tt>
  # 
  # Sets the level at which the cache logger should log it's messages. 
  # Default is: <tt>:info</tt>
  # 
  # Available options are: [:fatal, :error, :warn, :info, :debug]
  # 
  # 
  # == Basic Page Caching
  # 
  # By default caching only happens in <tt>:production</tt> mode, and via the Sinatra render methods, erb(), etc,
  # 
  # So asuming we have the following setup (continued from above)
  # 
  # 
  #   class YourApp
  # 
  #     <snip...>
  # 
  #     set :cache_output_dir, "/full/path/2/app/root/public/system/cache"
  # 
  #     <snip...>
  # 
  #     get('/') { erb(:index) }            # => is cached as '../index.html'
  # 
  #     get('/contact') { erb(:contact) }   # => is cached as '../contact.html'
  # 
  #     # NB! the trailing slash on the URL
  #     get('/about/') { erb(:about) }      # => is cached as '../about/index.html'
  # 
  #     get('/feed.rss') { builder(:feed) }  # => is cached as '../feed.rss' 
  #     # NB! uses the extension of the passed URL, 
  #     # but DOES NOT ensure the format of the content based on the extension provided.
  # 
  #     # complex URL with multiple possible params  
  #     get %r{/articles/?([\s\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?/?([\w-]+)?}  do
  #       erb(:articles)
  #     end
  #     # with the '/articles/a/b/c  => is cached as ../articles/a/b/c.html
  # 
  #     # NB! the trailing slash on the URL
  #     # with the '/articles/a/b/c/  => is cached as ../articles/a/b/c/index.html
  # 
  #     # CSS caching via Sass  # => is cached as '.../css/screen.css'
  #     get '/css/screen.css' do 
  #       content_type 'text/css'
  #       sass(:'css/screen')
  #     end
  # 
  #     # to turn off caching on certain pages.
  #     get('/dont/cache/this/page') { erb(:aview, :cache => false) }   # => is NOT cached
  # 
  # 
  #     # NB! any query string params - [ /?page=X&id=y ] - are stripped off and TOTALLY IGNORED 
  #     # during the caching process.
  # 
  #   end
  # 
  # OK, that's about all you need to know about basic Page Caching right there. Read the above example
  # carefully until you understand all the variations.
  # 
  # 
  # == Fragment Caching 
  # 
  # If you just need to cache a fragment of a page, then you would do as follows:
  # 
  #   class YourApp
  # 
  #     set :cache_fragments_output_dir, "/full/path/2/fragments/store/location"
  # 
  #   end
  # 
  # Then in your views / layouts add the following:
  # 
  #   <% cache_fragment(:name_of_fragment) do %>
  #    # do something worth caching
  #   <% end %>
  # 
  # 
  # Each fragment is stored in the same directory structure as your request
  # so, if you have a request like this:
  # 
  #   get '/articles/2010/02' ...
  # 
  # ...the cached fragment will be stored as:
  # 
  #   ../tmp/cache_fragments/articles/2010/02/< name_of_fragment >.html
  # 
  # This enables you to use similar names for your fragments or have 
  # multiple URLs use the same view / layout.
  # 
  # 
  # === An important limitation
  # 
  # The fragment caching is dependent upon the final URL, so in the case of 
  # a blog, where each article uses the same view, but through different URLs,
  # each of the articles would cache it's own fragment, which is ineffecient.
  # 
  # To sort-of deal with this limitation I have temporarily added a very hackish 
  # 'fix' through adding a 2nd parameter (see example below), which will remove the 
  # last part of the URL and use the rest of the URL as the stored fragment path.
  # 
  # So given the URL:
  # 
  #   get '/articles/2010/02/fragment-caching-with-sinatra-cache' ...
  # 
  # and the following <tt>#cache_fragment</tt> declaration in your view
  # 
  #   <% cache_fragment(:name_of_fragment, :shared) do %>
  #     # do something worth caching
  #   <% end %>
  # 
  # ...the cached fragment would be stored as:
  # 
  #   ../tmp/cache_fragments/articles/2010/02/< name_of_fragment >.html
  # 
  # Any other URLs with the same URL root, like...
  # 
  #   get '/articles/2010/02/writing-sinatra-extensions' ...
  # 
  # ... would use the same cached fragment.
  # 
  # 
  # <b>NB!</b> currently only supports one level, but Your fork might fix that ;-)
  # 
  # 
  # == Cache Expiration
  # 
  # <b>Under development, and not entirely final.</b> See Todo's below for more info.
  # 
  # 
  # To expire a cached item - file or fragment - you use the :cache_expire() method.
  # 
  # 
  #   cache_expire('/contact')  =>  expires ../contact.html
  # 
  # 
  #   # NB! notice the trailing slash
  #   cache_expire('/contact/')  =>  expires ../contact/index.html
  # 
  # 
  #   cache_expire('/feed.rss')  =>  expires ../feed.rss
  # 
  # 
  # To expire a cached fragment:
  # 
  #   cache_expire('/some/path', :fragment => :name_of_fragment )  
  # 
  #     =>  expires ../some/path/:name_of_fragment.html
  # 
  # 
  # 
  # == A few important points to consider 
  # 
  # 
  # === The DANGERS of URL query string params
  # 
  # By default the caching ignores the query string params, but that's not the only problem with query params.
  # 
  # Let's say you have a URL like this:
  # 
  #   /products/?product_id=111
  # 
  # and then inside that template [ .../views/products.erb ], you use the <tt>params[:product_id]</tt> 
  # param passed in for some purpose.
  # 
  #   <ul>
  #     <li>Product ID: <%= params[:product_id] %></li>  # => 111
  #     ...
  #   </ul>
  # 
  # If you cache this URL, then the cached file [ ../cache/products.html ] will be stored with that
  # value embedded. Obviously not ideal for any other similar URLs with different <tt>product_id</tt>'s
  # 
  # To overcome this issue, use either of these two methods.
  # 
  #   # in your_app.rb
  # 
  #   # turning off caching on this page
  # 
  #   get '/products/' do
  #     ...
  #     erb(:products, :cache => false)
  #   end
  # 
  #   # or
  # 
  #   # rework the URLs to something like '/products/111 '
  # 
  #   get '/products/:product_id' do
  #     ...
  #     erb(:products)
  #   end
  # 
  # 
  # 
  # Thats's about all the information you need to know.
  # 
  # 
  module Cache
    
    module Helpers 
      
      ##
      # This method either caches the code fragment and then renders it,
      # or locates the cached fragement and renders that.
      # 
      # By default the cached fragement is stored in the ../tmp/cache_fragments/ 
      # directory at the root of your app.
      # 
      # Each fragment is stored in the same directory structure as your request
      # so, if you have a request like this:
      # 
      #   get '/articles/2010/02' ...
      # 
      # ...the cached fragment will be stored as:
      # 
      #   ../tmp/cache_fragments/articles/2010/02/< name_of_fragment >.html
      # 
      # This enables you to use similar names for your fragments or have 
      # multiple URLs use the same view / layout.
      # 
      # ==== Examples
      # 
      #   <% cache_fragment(:name_of_fragment) do %>
      #     # do something worth caching
      #   <% end %>
      # 
      # === GOTCHA
      # 
      # The fragment caching is dependent upon the final URL, so in the case of 
      # a blog, where each article uses the same view, but through different URLs,
      # each of the articles would cache it's own fragment.
      # 
      # To sort-of deal with this limitation I have added a very hackish 'fix'
      # through adding a 2nd parameter (see example below), which will 
      # remove the last part of the URL and use the rest of the URL as 
      # the stored fragment path.
      # 
      # ==== Example
      # 
      # Given the URL:
      # 
      #   get '/articles/2010/02/fragment-caching-with-sinatra-cache' ...
      # 
      # and the following <tt>#cache_fragment</tt> declaration in your view
      # 
      #   <% cache_fragment(:name_of_fragment, :shared) do %>
      #     # do something worth caching
      #   <% end %>
      # 
      # ...the cached fragment would be stored as:
      # 
      #   ../tmp/cache_fragments/articles/2010/02/< name_of_fragment >.html
      # 
      # Any other URLs with the same URL root, like...
      # 
      #   get '/articles/2010/02/writing-sinatra-extensions' ...
      # 
      # ... would use the same cached fragment.
      # 
      # @api public
      def cache_fragment(fragment_name, shared = nil, &block) 
        # 1. check for a block, there must always be a block
        raise ArgumentError, "Missing block" unless block_given?
        
        # 2. get the fragment path, by combining the PATH_INFO of the request, and the fragment_name
        dir_structure = request.path_info.empty? ? '' : request.path_info.gsub(/^\//,'').gsub(/\/$/,'')
        # if we are sharing this fragment with other URLs (as in the all the articles in a category of a blog) 
        # then lob off the last part of the URL
        unless shared.nil?
          dirs = dir_structure.split('/')
          dir_structure = dirs.first(dirs.length-1).join('/')
        end
        cf = "#{settings.cache_fragments_output_dir}/#{dir_structure}/#{fragment_name}.html"
        # 3. ensure the fragment cache directory exists for this fragment
        FileUtils.mkdir_p(File.dirname(cf)) rescue "ERROR: could NOT create the cache directory: [ #{File.dirname(cf)} ]"
        
        # 3. check if the fragment is already cached ?
        if test(?f, cf)
          # 4. yes. cached, so load it up into the ERB buffer .  Sorry, don't know how to do this for Haml or any others.
          block_content = IO.read(cf)
        else
          # 4. not cached, so process the block and then cache it
          block_content = capture_html(&block) if block_given?
          # 5. add some timestamp comments around the fragment, if the end user wants it
          if settings.cache_fragments_wrap_with_html_comments
            content_2_cache = "<!-- cache fragment: #{dir_structure}/#{fragment_name} -->"
            content_2_cache << block_content
            content_2_cache << "<!-- /cache fragment: #{fragment_name} cached at [ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] -->\n"
          else
            content_2_cache = block_content
          end
          # 6. write it to cache
          cache_write_file(cf, content_2_cache)
        end
        # 5. 'return' the content by
        block_is_template?(block) ? concat_content(block_content) : block_content
      end
      # for future versions once old habits are gone
      # alias_method :cache, :cache_fragment
      
      
      ##
      # <b>NB!! Deprecated method.</b>
      # 
      # Just returns the content after throwing out a warning.
      # 
      def cache(content, opts={}) 
        warn("Deprecated method, caching is now happening by default if the :cache_enabled option is true")
        content
      end
      
      
      ##
      # Expires the cached file (page) or fragment.
      #  
      # ==== Examples
      # 
      #   cache_expire('/contact')  =>  expires ../contact.html
      # 
      #   cache_expire('/feed.rss')  =>  expires ../feed.rss
      # 
      # To expire a cached fragment:
      # 
      #   cache_expire('/some/path', :fragment => :name_of_fragment )  
      #     =>  expires ../some/path/:name_of_fragment.html
      # 
      # 
      # @api public
      def cache_expire(path, options={}) 
        # 1. bail quickly if we don't have caching enabled
        return unless settings.cache_enabled
        options = { :fragment => false }.merge(options)
        
        if options[:fragment] # dealing with a fragment 
          dir_structure = path.gsub(/^\//,'').gsub(/\/$/,'')
          file_path = "#{settings.cache_fragments_output_dir}/#{dir_structure}/#{options[:fragment]}.html"
        else
          file_path = cache_file_path(path)
        end
        
        if test(?f, file_path)
          File.delete(file_path)
          log(:info,"Expired [#{file_path.sub(settings.root,'')}] successfully")
        else
          log(:warn,"The cached file [#{file_path}] could NOT be expired as it was NOT found")
        end
      end
      
      
      ##
      # Prints a basic HTML comment with a timestamp in it, so that you can see when a file was cached last.
      # 
      # *NB!* IE6 does NOT like this to be the first line of a HTML document, so output
      # inside the <head> tag. Many hours wasted on that lesson ;-)
      # 
      # ==== Examples 
      # 
      #   <%= cache_timestamp %>  # => <!--  page cached: 2009-12-21 12:00:00 -->
      # 
      # @api public
      def cache_timestamp 
        if settings.cache_enabled && settings.cache_environment == settings.environment
          "<!-- page cached: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} -->\n"
        end
      end
      # backwards compat and syntactic sugar for others
      alias_method :cache_page_timestamp, :cache_timestamp
      alias_method :page_cached_at, :cache_timestamp
      
      
      ## PRIVATE METHODS
      private
        
        ##
        # Converts the PATH_INFO path into the full cached file path.
        # 
        # ==== GOTCHA:
        # 
        # <b>NB!</b> completely ignores the URL query params passed such as 
        # in this example:
        # 
        #   /products?page=2 
        # 
        # To capture and cache those query strings, please do as follows:
        # 
        #   get 'products/page/:page' { ... }  # in your Sinatra app
        # 
        #   /products/page/2  => .../public/cache/products/page/2.html
        # 
        #  
        # ==== Examples
        # 
        #   /  => .../public/cache/index.html
        # 
        #   /contact  => .../public/cache/contact.html
        # 
        #   /contact/  => .../public/cache/contact/index.html
        # 
        # 
        # @api public
        def cache_file_path(in_path = nil) 
          path = settings.send(:cache_output_dir).dup
          
          
          path_info = in_path.nil? ? request.path_info : in_path
          if (path_info.empty? || path_info == "/" ) 
            path << "/index"
          elsif ( path_info[-1, 1] == '/' )
            path << ::Rack::Utils.unescape(path_info.chomp('/') << '/index')
          else
             path << ::Rack::Utils.unescape(path_info.chomp('/'))
          end
          path << settings.cache_page_extension if File.extname(path) == ''
          return path
        end
        
        ##
        # Writes the cached file to disk, only during GET requests, 
        # and then returns the content.
        # 
        # ==== Examples
        # 
        # 
        # @api private
        def cache_write_file(cache_file, content) 
          # only cache GET request [http://rack.rubyforge.org/doc/classes/Rack/Request.html#M000239]
          if request.get?
            FileUtils.mkdir_p(File.dirname(cache_file)) rescue "ERROR: could NOT create the cache directory: [ #{File.dirname(cache_file)} ]"
            File.open(cache_file, 'wb'){ |f| f << content}
          end
          return content
        end
        
        ##
        # Establishes the file name of the cached file from the path given
        # 
        # @api private
        def cache_file_name(path, options={}) 
          name = (path.empty? || path == "/") ? "index" : Rack::Utils.unescape(path.sub(/^(\/)/,'').chomp('/'))
          name << settings.cache_page_extension unless (name.split('/').last || name).include? '.'
          return name
        end
        
        ##
        # Sets the full path to the cached page/file
        # Dependent upon Sinatra.options .public and .cache_dir variables being present and set.
        # 
        # 
        # @api private
        def cache_page_path(path, options={}) 
          # test if given a full path rather than relative path, otherwise join the public path to cache_dir 
          # and ensure it is a full path
          cache_dir = (settings.cache_output_dir == File.expand_path(settings.cache_output_dir)) ? 
              settings.cache_output_dir : File.expand_path("#{settings.public}/#{settings.cache_output_dir}")
          cache_dir = cache_output_dir[0..-2] if cache_dir[-1,1] == '/'
          "#{cache_dir}/#{cache_file_name(path, options)}"
        end
        
        ##
        # Convenience method that handles logging of Cache related stuff.
        # 
        # Uses Sinatra::Logger's #logger method if available, otherwise just
        # puts out the log message.
        # 
        def log(scope, msg) 
          if settings.cache_logging
            if scope.to_sym == settings.cache_logging_level.to_sym
              if self.respond_to?(:logger)
                logger.send(scope, msg) 
              else
                puts "#{scope.to_s.upcase}: #{msg}"
              end
            end
          end
        end
        
      
    end #/ Helpers
    
    
    ##
    # The default options:
    # 
    # * +:cache_enabled+ => toggle for the cache functionality. Default is: +false+
    # 
    # * +:cache_environment+ => sets the environment during which to cache. Default is: +:production+
    # 
    # * +:cache_page_extension+ => sets the default extension for cached files. Default is: +.html+
    # 
    # * +:cache_output_dir+ => sets cache directory where cached files are stored. Default is: == "/path/2/your/app/public"
    #   Although you can set it to the more ideal '<tt>..public/system/cache/</tt>' 
    #   if you can get that to work with your webserver setup.
    # 
    # * +:cache_fragments_output_dir+ => sets the directory where cached fragments are stored. 
    #   Default is the '../tmp/cache_fragments/' directory at the root of your app.
    # 
    # * +:cache_fragments_wrap_with_html_comments+ => toggle for wrapping the cached fragment in HTML comments. 
    #   Default is: +true+
    # 
    # * +:cache_logging+ => toggle for logging the cache calls. Default is: +true+
    # 
    # * +:cache_logging_level+ => sets the level of the cache logger. Default is: <tt>:info</tt>.<br>
    #   Available options are: [:fatal, :error, :warn, :info, :debug]
    # 
    # 
    def self.registered(app)
      app.register(Sinatra::OutputBuffer)
      app.helpers Cache::Helpers
      
      ## CONFIGURATIONS::
      app.set :cache_enabled, false
      app.set :cache_environment, :production
      app.set :cache_page_extension, '.html'
      app.set :cache_output_dir, lambda { app.public }
      app.set :cache_fragments_output_dir, lambda { "#{app.root}/tmp/cache_fragments" }
      app.set :cache_fragments_wrap_with_html_comments, true
      
      app.set :cache_logging, true
      app.set :cache_logging_level, :info
      
      
      ## add the extension specific options to those inspectable by :settings_inspect method
      if app.respond_to?(:sinatra_settings_for_inspection)
        %w( cache_enabled cache_environment cache_page_extension cache_output_dir
            cache_fragments_output_dir cache_fragments_wrap_with_html_comments 
            cache_logging cache_logging_level
        ).each do |m|
          app.sinatra_settings_for_inspection << m
        end
      end
      
    end #/ self.registered
    
  end #/ Cache
  
  register(Sinatra::Cache) # support classic apps
  
end #/ Sinatra