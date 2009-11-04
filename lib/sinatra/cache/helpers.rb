
require 'sinatra/base'
require 'alt/rext/string/access'

module Sinatra 
  
  # == Sinatra::Cache 
  # 
  # Simple Page Caching for your Sinatra[www.sinatrarb.com] applications.
  # 
  # === Usage:
  # 
  # Just add the extension as a helper in your sub-classed Sinatra application.
  # 
  #   class YourApp < Sinatra::Base
  #     
  #     helpers( Sinatra::Cache)
  #     
  #     # toggle for the cache functionality.
  #     set :cache_enabled, true
  #     # sets the default extension for cached files
  #     set :cache_page_extension, '.html'
  #     # sets the Cache output dir to the root of the /public directory.
  #     set :cache_output_dir, '' # was :cache_dir
  #     
  #     <snip...>
  #   end
  # 
  # See the method definitions for further information.
  # 
  # === Dependencies:
  # 
  # This extension depends on the following:
  # 
  # ==== Ruby Gems:
  # 
  # * sinatra
  # 
  # ==== Extensions: 
  # 
  # * None
  # 
  # === Configurations:
  # 
  # * None
  # 
  # === Routes: 
  # 
  # * None
  # 
  # === Code Inspirations:
  # 
  # * The Rails code by DHH & Rails Core Team
  # * Merb
  # 
  module Cache
    
    
    module Helpers 
      
      
      # ##
      # # TODO: add some comments here
      # #  
      # # ==== Examples
      # # 
      # # 
      # # @api public/private
      # def cache_fragment(fragment_name, cached_content = '', &block)
      #   # 1. check if the fragment is already cached, if so, use it
      #   cf = "#{self.class.cache_fragments_output_dir}/#{fragment_name}.html"
      #   # return IO.read(cf) if test(?f, cf) 
      #   
      #   # 2. No cached fragment, so cache it
      #   
      #   cached_content = block_given? ? yield : cached_content
      #   # add a time stamp
      #   content_2_cache = "<!-- cache fragment: #{fragment_name} -->\n"
      #   content_2_cache << cached_content
      #   content_2_cache << "<!-- /cache fragment: #{fragment_name} cached at [ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] -->\n"
      #   cache_write_file(cf, content_2_cache)
      #   
      #   return "RETURNED #{cached_content} /RETURNED"
      # end
      # alias_method :cache, :cache_fragment
      
      # ##
      # # NB!! Deprecated method.
      # # 
      # # Caches the given URI to a html file in /public
      # # 
      # #    >> cache( erb(:contact, :layout => :layout))
      # #      =>  returns the HTML output written to /public/<CACHE_DIR_PATH>/contact.html
      # # 
      # # Also accepts an Options Hash, with the following options:
      # #  * :extension => in case you need to change the file extension
      # #  
      # #  TODO:: implement the opts={} hash functionality. What other options are needed?
      # # 
      # def cache(content, opts={})
      #   warn("Deprecated method, caching is now happening by default if the :cache_enabled option is true")
      #   content
      # end
      
      ##
      # Expires the cached URI (as .html file) in /public
      # 
      # ==== Examples 
      # 
      #    cache_expire('/contact')
      #     =>  deletes the /public/<CACHE_DIR_PATH>/contact.html page
      # 
      #   cache_expire('/contact/')  # NB! trailing slash
      #   
      #   =>  deletes the /public/<CACHE_DIR_PATH>/contact/index.html page
      # 
      # 
      # You can even use it within the declared routes, to delete the existing cached page.
      # 
      #   # deletes the /public/<CACHE_DIR_PATH>/contact.html page as well
      #   get '/contact' do 
      #     cache_expire
      #     <snip...>
      #   end
      #
      #  TODO:: implement the options={} hash functionality. What options are really needed ? 
      def cache_expire(path = nil, opts={})
        return unless options.cache_enabled
        
        path = (path.nil?) ? cache_page_path(request.path_info) : cache_page_path(path)
        if File.exist?(path)
          File.delete(path)
          log("Expired Page deleted at: [#{path}]",:info)
        else
          log("No Expired Page was found at the path: [#{path}]",:info)
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
        if self.class.cache_enabled && self.class.cache_environment == self.class.environment
          "<!-- page cached: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} -->\n"
        # else  
        #   ''
        end
      end
      # backwards compat
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
        # 
        #   /contact  => .../public/cache/contact.html
        # 
        # 
        #   /contact/  => .../public/cache/contact/index.html
        # 
        # 
        # @api public
        def cache_file_path 
          path = self.class.send(:cache_output_dir).dup
          
          cache_page_extension = self.class.cache_page_extension
          path_info = request.path_info
          if (path_info.empty? || path_info == "/" ) 
            path << "/index"
          elsif ( path_info[-1, 1] == '/' )
            path << ::Rack::Utils.unescape(path_info.chomp('/') << '/index')
          else
             path << ::Rack::Utils.unescape(path_info.chomp('/'))
          end
          path << cache_page_extension if File.extname(path) == ''
          return path
        end
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api public
        def cache_write_file(cache_file, content) 
          FileUtils.mkdir_p(File.dirname(cache_file)) rescue "ERROR: could NOT create the cache directory: [ #{File.dirname(cache_file)} ]"
          File.open(cache_file, 'wb'){ |f| f << content}
          return content
        end
        
        ##
        # Establishes the file name of the cached file from the path given
        # 
        # TODO:: implement the opts={} functionality, and support for custom extensions on a per request basis. 
        # 
        # @api private
        def cache_file_name(path,opts={}) 
          name = (path.empty? || path == "/") ? "index" : Rack::Utils.unescape(path.sub(/^(\/)/,'').chomp('/'))
          name << self.class.cache_page_extension unless (name.split('/').last || name).include? '.'
          return name
        end
        
        ##
        # Sets the full path to the cached page/file
        # Dependent upon Sinatra.options .public and .cache_dir variables being present and set.
        # 
        # 
        # @api private
        def cache_page_path(path,opts={}) 
          # test if given a full path rather than relative path, otherwise join the public path to cache_dir 
          # and ensure it is a full path
          cache_dir = (self.class.cache_output_dir == File.expand_path(self.class.cache_output_dir)) ? 
              self.class.cache_output_dir : File.expand_path("#{self.class.public}/#{self.class.cache_output_dir}")
          cache_dir = cache_output_dir[0..-2] if cache_dir[-1,1] == '/'
          "#{cache_dir}/#{cache_file_name(path, opts)}"
        end
        
        ##
        #  TODO:: this implementation really stinks, how do I incorporate Sinatra's logger??
        # 
        def log(msg, scope=:debug) 
          if self.class.cache_logging
            "Log: msg=[#{msg}]" if scope == self.class.cache_logging_level
          else
            # just ignore the stuff...
            # puts "just ignoring msg=[#{msg}] since cache_logging => [#{options.cache_logging.to_s}]"
          end
        end
        
      
    end #/ Helpers
    
    
    # Sets the default options:
    # 
    #  * +:cache_enabled+ => toggle for the cache functionality. Default is: +true+
    #  * +:cache_page_extension+ => sets the default extension for cached files. Default is: +.html+
    #  * +:cache_output_dir+ => sets cache directory where cached files are stored. Default is: ''(empty) == root of /public.<br>
    #      set to empty, since the ideal 'system/cache/' does not work with Passenger & mod_rewrite :(
    #  * +cache_logging+ => toggle for logging the cache calls. Default is: +true+
    #  * +cache_logging_level+ => sets the level of the cache logger. Default is: <tt>:info</tt>.<br>
    #      Options:(unused atm) [:info, :warn, :debug]
    # 
    def self.registered(app)
      app.helpers Cache::Helpers
      
      ## CONFIGURATIONS::
      app.set :cache_enabled, false
      app.set :cache_environment, :production
      app.set :cache_page_extension, '.html'
      app.set :cache_output_dir, ''
      app.set :cache_fragments_output_dir, "#{app.cache_output_dir}/cache_fragments"
      app.set :cache_logging, true
      app.set :cache_logging_level, :info
      app.set :cache_fragments, {}
      
      
    end #/ self.registered
    
  end #/ Cache
  
  # register(Sinatra::Cache) # not really needed here
  
end #/ Sinatra