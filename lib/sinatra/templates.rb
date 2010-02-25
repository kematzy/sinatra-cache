
module Sinatra 
  
  ##
  # Sinatra::Templates
  # 
  # Monkey-patches the private <tt>#render</tt> method, 
  # in order to support 'auto-magic' cache functionality.
  # 
  # 
  module Templates 
    
    private
      
      def render(engine, data, options={}, locals={}, &block) 
        # merge app-level options
        options = settings.send(engine).merge(options) if settings.respond_to?(engine)
        
        # extract generic options
        locals = options.delete(:locals) || locals || {}
        views = options.delete(:views) || settings.views || "./views"
        layout = options.delete(:layout)
        layout = :layout if layout.nil? || layout == true
        
        # set the cache related options
        cache_enabled = settings.respond_to?(:cache_enabled) ? settings.send(:cache_enabled) : false
        cache_output_dir = settings.send(:cache_output_dir)  if settings.respond_to?(:cache_output_dir)
        # raise Exception, "The Sinatra::Cache cache_output_dir variable is pointing to a non-existant directory cache_output_dir=[#{cache_output_dir}]" unless test(?d, cache_output_dir)
        cache_option = options.delete(:cache)
        cache_option = true if cache_option.nil?
        
        # compile and render template
        template = compile_template(engine, data, options, views)
        output = template.render(self, locals, &block)
        
        # render layout
        if layout
          begin
            options = options.merge(:views => views, :layout => false)
            output = render(engine, layout, options, locals) { output }
            # Cache the content or just return it
            (cache_enabled && settings.send(:environment) == settings.cache_environment) ? 
                cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"")) : output
          rescue Errno::ENOENT
          end
        end
        
        # rendering without a layout
        (cache_enabled && cache_option && settings.send(:environment) == settings.cache_environment) ? 
            cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"") ) : output
      end
      
  end #/module Templates
  
end #/module Sinatra 
