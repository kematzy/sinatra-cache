
require 'fileutils'
require 'logger'



module Sinatra 
  
  class Default < Base 
    #  NOTE:: Is this the correct way to do this ?? 
    # toggle for cache functionality
    set :cache_enabled, true
    # default extension for caching
    set :cache_page_extension, '.html'
    # set Cache dir to Root of Public.
    set :cache_dir, ''  # set to empty, since the ideal 'system/cache/' does not work with Passenger & mod_rewrite :(
    # 
    set :cache_logging, true
    #
    set :cache_logging_level, :debug
    
  end #/class Default < Base
  
  # Page Caching module
  # 
  module Cache
    
    VERSION = 'Sinatra::Cache v0.0.2'
    
    def self.version; VERSION; end;
    
    
    # Caches the given URI to a html file in /public
    # 
    # <b>Usage:</b>
    #    >> cache( erb(:contact, :layout => :layout))
    #      =>  returns the HTML output written to /public/<CACHE_DIR_PATH>/contact.html
    #
    #  TODO:: implement the options={} hash functionality. What options are really needed ? 
    def cache(content, options={})
      return content unless Sinatra.options.cache_enabled
      
      unless content.nil?
        path = cache_page_path(request.path_info,options)
        FileUtils.makedirs(File.dirname(path))
        open(path, 'wb+') { |f| f << content }
        log.info( "Cached Page: [#{path}]") 
        content
      end
    end
    
    # Expires the cached URI (as .html file) in /public
    # 
    # <b>Usage:</b>
    #    >> expire_cache('/contact')
    #      =>  deletes the /public/<CACHE_DIR_PATH>contact.html page
    # 
    #    get '/contact' do 
    #     expire_cache   # deletes the /public/<CACHE_DIR_PATH>contact.html page as well
    #    end
    #
    #  TODO:: implement the options={} hash functionality. What options are really needed ? 
    def expire_cache(path = nil, options={})
      return unless Sinatra.options.cache_enabled
      
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
      "<!-- page cached: #{Time.now.strftime("%Y-%d-%m %H:%M:%S")} -->" if Sinatra.options.cache_enabled
    end
    
    
    private
      
      # establishes the file name of the cached file from the path given
      #  TODO:: implement the options={} functionality. Not sure IF we really need the :extension option or not?? 
      def cache_file_name(path,options={})
        name = (path.empty? || path == "/") ? "index" : Rack::Utils.unescape(path.sub(/^(\/)/,'').chomp('/'))
        name << Sinatra.options.cache_page_extension unless (name.split('/').last || name).include? '.'
        return name
      end
      
      # sets the full path to the cached page/file
      # Dependent upon Sinatra.options .public and .cache_dir variables being present and set.
      # 
      def cache_page_path(path,options={})
        "#{Sinatra.options.public}/#{Sinatra.options.cache_dir}#{cache_file_name(path,options)}"
      end
      
      
      def log(msg,scope=:info)
        require 'logger'
        logger ||= Logger.new(STDERR)
        logger.level = Logger::WARN
        # $LOG.level = Logger::INFO
      end
      
  end #/module Cache
  
  Sinatra::Base.register Sinatra::Cache
  
end #/module Sinatra