
module Sinatra 
  
  
  module Templates 
    
    private
      
      ##
      # TODO: add some comments here
      #  
      # ==== Examples
      # 
      # 
      def render(engine, template, options={}, locals={})
        # merge app-level options
        options = self.class.send(engine).merge(options) if self.class.respond_to?(engine)
        
        # extract generic options
        layout = options.delete(:layout)
        layout = :layout if layout.nil? || layout == true
        views = options.delete(:views) || self.class.views || "./views"
        locals = options.delete(:locals) || locals || {}
        
        # set the cache related options
        cache_enabled = self.class.send(:cache_enabled)  if self.class.respond_to?(:cache_enabled)
        cache_enabled = false unless cache_enabled === true
        cache_output_dir = self.class.send(:cache_output_dir)  if self.class.respond_to?(:cache_output_dir)
        # raise Exception, "The Sinatra::Cache cache_output_dir variable is pointing to a non-existant directory cache_output_dir=[#{cache_output_dir}]" unless test(?d, cache_output_dir)
        cache_option = options.delete(:cache)
        cache_option = true if cache_option.nil?
        
        # render template
        data, options[:filename], options[:line] = lookup_template(engine, template, views)
        output = __send__("render_#{engine}", data, options, locals)
        
        # render layout
        if layout 
          data, options[:filename], options[:line] = lookup_layout(engine, layout, views)
          if data
            output = __send__("render_#{engine}", data, options, locals) { output }
          end
          (cache_enabled && self.class.send(:environment) == self.class.cache_environment) ? 
              cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"")) : output
        else
          # rendering without a layout
          (cache_enabled && cache_option && self.class.send(:environment) == self.class.cache_environment) ? 
              cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"") ) : output
        end
      end
      
  end #/module Templates
  
end #/module Sinatra 
