
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
        options[:outvar] ||= '@_out_buf'
        
        # extract generic options
        locals          = options.delete(:locals) || locals         || {}
        views           = options.delete(:views)  || settings.views || "./views"
        @default_layout = :layout if @default_layout.nil?
        layout          = options.delete(:layout)
        layout          = @default_layout if layout.nil? or layout == true
        content_type    = options.delete(:content_type) || options.delete(:default_content_type)
        
        # set the cache related options
        cache_enabled = settings.respond_to?(:cache_enabled) ? settings.send(:cache_enabled) : false
        cache_output_dir = settings.send(:cache_output_dir)  if settings.respond_to?(:cache_output_dir)
        # raise Exception, "The Sinatra::Cache cache_output_dir variable is pointing to a non-existant directory cache_output_dir=[#{cache_output_dir}]" unless test(?d, cache_output_dir)
        cache_option = options[:cache]
        cache_option = true if cache_option.nil?
        
        # compile and render template
        layout_was      = @default_layout
        @default_layout = false
        template        = compile_template(engine, data, options, views)
        output          = template.render(self, locals, &block)
        @default_layout = layout_was
        
        # render layout
        if layout
          begin
            options = options.merge(:views => views, :layout => false)
            output = render(engine, layout, options, locals) { output }
            # Cache the content or just return it
            (cache_enabled && cache_option && settings.send(:environment) == settings.cache_environment) ?
                cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"")) : output
          rescue Errno::ENOENT
          end
        end
        
        # rendering without a layout
        (cache_enabled && cache_option && settings.send(:environment) == settings.cache_environment) ? 
            cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"") ) : output
            
        output.extend(ContentTyped).content_type = content_type if content_type
        output
      end
      
  end #/module Templates
  
end #/module Sinatra 
