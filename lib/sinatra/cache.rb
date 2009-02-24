require 'fileutils'
# require 'sinatra/base'

module Sinatra 
    
  # Sinatra Caching module
  # 
  module Cache
    
    VERSION = 'Sinatra::Cache v0.0.2'
    def self.version; VERSION; end
    
    
    module Helpers
      
      # Caches the given URI to a html file in /public
      # 
      # <b>Usage:</b>
      #    >> cache( erb(:contact, :layout => :layout))
      #      =>  returns the HTML output written to /public/<CACHE_DIR_PATH>/contact.html
      # 
      # Also accepts an Options Hash, with the following options:
      #  * :extension => in case you need to change the file extension
      #  * 
      #  TODO:: implement the options={} hash functionality. What options are needed?
      def cache(content, options={})
        return content unless options.cache_enabled
        # return content unless self.cache_enabled
        
        unless content.nil?
          path = cache_page_path(request.path_info,options)
          log.info("path=[#{path}]")
          # FileUtils.makedirs(File.dirname(path))
          # open(path, 'wb+') { |f| f << content }
          # log.info( "Cached Page: [#{path}]") 
          content
        end
      end
      
      # Expires the cached URI (as .html file) in /public
      # 
      # <b>Usage:</b>
      #    >> cache_expire('/contact')
      #      =>  deletes the /public/<CACHE_DIR_PATH>contact.html page
      # 
      #    get '/contact' do 
      #     cache_expire   # deletes the /public/<CACHE_DIR_PATH>contact.html page as well
      #    end
      #
      #  TODO:: implement the options={} hash functionality. What options are really needed ? 
      def cache_expire(path = nil, options={})
        return unless options.cache_enabled

        path = (path.nil?) ? cache_page_path(request.path_info) : cache_page_path(path)
        if File.exist?(path)
          File.delete(path)
          log.info( "Expired Page deleted at: [#{path}]")
        else
          log.info( "No Expired Page was found at the path: [#{path}]")
        end
      end
      
      
      # Prints a basic HTML comment with a timestamp in it.
      # 
      # *NB!* IE6 does NOT like this to be the first line of a HTML document, so output
      # inside the <head> tag. Many hours wasted on that lesson ;-)
      # 
      # <b>Usage:</b>
      #    >> <%= page_cached_timestamp %>
      #      => <!--  page cached: 2008-08-01 12:00:00 -->
      #
      def page_cached_timestamp
        "<!-- page cached: #{Time.now.strftime("%Y-%d-%m %H:%M:%S")} -->" if options.cache_enabled
      end
      
      
    end #/module Helpers
    
    
    # 
    # 
    def self.registered(app)
      app.helpers(Cache::Helpers)
      
      # toggle for cache functionality
      app.set :cache_enabled, true
      # default extension for cached files
      app.set :cache_page_extension, '.html'
      # set Cache dir to Root of Public.
      app.set :cache_dir, ''  # set to empty, since the ideal 'system/cache/' does not work with Passenger & mod_rewrite :(
      # toggle for logging cache calls
      app.set :cache_logging, true
      # set the level of the cache logger. Default is :debug. Options: [:info, :warn, :debug]
      app.set :cache_logging_level, :debug
    end
    
    # 
    # 
    # private
    #   
      # establishes the file name of the cached file from the path given
      #  TODO:: implement the opts={} functionality. Not sure IF we really need the :extension option or not?? 
      def cache_file_name(path,opts={})
        name = (path.empty? || path == "/") ? "index" : Rack::Utils.unescape(path.sub(/^(\/)/,'').chomp('/'))
        name << options.cache_page_extension unless (name.split('/').last || name).include? '.'
        return name
      end
      
      # sets the full path to the cached page/file
      # Dependent upon Sinatra.options .public and .cache_dir variables being present and set.
      # 
      def cache_page_path(path,opts={})
        # test if given a full path rather than relative path
        cache_dir = (options.cache_dir == File.expand_path(options.cache_dir)) ? options.cache_dir : "#{options.public}/#{options.cache_dir}"
        cache_dir = cache_dir[0..-2] if cache_dir[-1,1] == '/'
        "#{cache_dir}/#{cache_file_name(path,opts)}"
      end
      
      
      #  TODO:: need to make this work with the actual settings.... 
      def log(msg,scope=:debug)
        require 'logger'
        logger ||= Logger.new(STDERR)
        logger.level = Logger::DEBUG
        # $LOG.level = Logger::INFO
        logger.debug(msg)
      end
          
  end #/module Cache
  
  register(Sinatra::Cache)
  
end #/module Sinatra