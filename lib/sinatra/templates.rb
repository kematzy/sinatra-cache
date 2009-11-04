
module Sinatra 
  
  
  module Templates 
    
    # ##
    # # Override the sass method to add :cache => true as default
    # def sass(template, options={}, locals={})
    #   options = { :layout => false, :cache => true }.merge(options)
    #   render :sass, template, options, locals
    # end
    
    
    private
      
      ##
      # TODO: add some comments here
      #  
      # ==== Examples
      # 
      # 
      # @api public/private
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
        # cache_option = false if cache_option.nil?
        cache_option = true if cache_option.nil?
        
        # render template
        # data   = lookup_template(engine, template, views)
        # output = __send__("render_#{engine}", template, data, options, locals)
        data, options[:filename], options[:line] = lookup_template(engine, template, views)
        output = __send__("render_#{engine}", data, options, locals)
        
        # render layout
        if layout 
          data, options[:filename], options[:line] = lookup_layout(engine, layout, views)
          if data
            # out = __send__("render_#{engine}", layout, data, options, {}) { output }
            output = __send__("render_#{engine}", data, options, locals) { output }
          end
          
          # (cache_enabled && self.class.send(:environment) == :production) ? 
          (cache_enabled && self.class.send(:environment) == self.class.cache_environment) ? 
              cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"")) : output
         # if (cache_enabled && self.class.send(:environment) == :production)
         #    cache_write_file(cache_file_path, out.gsub(/\n\r?$/,""))
         #  else
         #    out
         #  end
        else
          # rendering without a layout
          
          
          
          
          # (cache_enabled && cache_option && self.class.send(:environment) == :production) ? 
          (cache_enabled && cache_option && self.class.send(:environment) == self.class.cache_environment) ? 
              cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"") ) : output
          
          # if (cache_enabled && cache_option && self.class.send(:environment) == :production)
          #   cache_write_file(cache_file_path, output.gsub(/\n\r?$/,"") )
          # else
          #   output
          # end
        end
      end
      
  end #/module Templates
  
  
  # # Template rendering methods. Each method takes the name of a template
  # # to render as a Symbol and returns a String with the rendered output,
  # # as well as an optional hash with additional options.
  # #
  # # `template` is either the name or path of the template as symbol
  # # (Use `:'subdir/myview'` for views in subdirectories), or a string
  # # that will be rendered.
  # #
  # # Possible options are:
  # #   :layout       If set to false, no layout is rendered, otherwise
  # #                 the specified layout is used (Ignored for `sass`)
  # #   :locals       A hash with local variables that should be available
  # #                 in the template
  # module Templates
  #   
  #   def erb(template, options={}, locals={})
  #     render :erb, template, options, locals
  #   end
  #   
  #   def haml(template, options={}, locals={})
  #     render :haml, template, options, locals
  #   end
  #   
  #   def sass(template, options={}, locals={})
  #     options[:layout] = false
  #     render :sass, template, options, locals
  #   end
  #   
  #   def builder(template=nil, options={}, locals={}, &block)
  #     options, template = template, nil if template.is_a?(Hash)
  #     template = lambda { block } if template.nil?
  #     render :builder, template, options, locals
  #   end
  #   
  # private
  #   
  #   def render(engine, template, options={}, locals={})
  #     # merge app-level options
  #     options = self.class.send(engine).merge(options) if self.class.respond_to?(engine)
  #     
  #     # extract generic options
  #     layout = options.delete(:layout)
  #     layout = :layout if layout.nil? || layout == true
  #     views = options.delete(:views) || self.class.views || "./views"
  #     locals = options.delete(:locals) || locals || {}
  #     
  #     # render template
  #     data, options[:filename], options[:line] = lookup_template(engine, template, views)
  #     output = __send__("render_#{engine}", data, options, locals)
  #     
  #     # render layout
  #     if layout
  #       data, options[:filename], options[:line] = lookup_layout(engine, layout, views)
  #       if data
  #         output = __send__("render_#{engine}", data, options, locals) { output }
  #       end
  #     end
  #     
  #     output
  #   end
  #   
  #   def lookup_template(engine, template, views_dir, filename = nil, line = nil)
  #     case template
  #     when Symbol
  #       load_template(engine, template, views_dir, options)
  #     when Proc
  #       filename, line = self.class.caller_locations.first if filename.nil?
  #       [template.call, filename, line.to_i]
  #     when String
  #       filename, line = self.class.caller_locations.first if filename.nil?
  #       [template, filename, line.to_i]
  #     else
  #       raise ArgumentError
  #     end
  #   end
  #   
  #   def load_template(engine, template, views_dir, options={})
  #     base = self.class
  #     while base.respond_to?(:templates)
  #       if cached = base.templates[template]
  #         return lookup_template(engine, cached[:template], views_dir, cached[:filename], cached[:line])
  #       else
  #         base = base.superclass
  #       end
  #     end
  #     
  #     # If no template exists in the cache, try loading from disk.
  #     path = ::File.join(views_dir, "#{template}.#{engine}")
  #     [ ::File.read(path), path, 1 ]
  #   end
  #   
  #   def lookup_layout(engine, template, views_dir)
  #     lookup_template(engine, template, views_dir)
  #   rescue Errno::ENOENT
  #     nil
  #   end
  #   
  #   def render_erb(data, options, locals, &block)
  #     original_out_buf = defined?(@_out_buf) && @_out_buf
  #     data = data.call if data.kind_of? Proc
  #     
  #     instance = ::ERB.new(data, nil, nil, '@_out_buf')
  #     locals_assigns = locals.to_a.collect { |k,v| "#{k} = locals[:#{k}]" }
  #     
  #     filename = options.delete(:filename) || '(__ERB__)'
  #     line = options.delete(:line) || 1
  #     line -= 1 if instance.src =~ /^#coding:/
  #     
  #     render_binding = binding
  #     eval locals_assigns.join("\n"), render_binding
  #     eval instance.src, render_binding, filename, line
  #     @_out_buf, result = original_out_buf, @_out_buf
  #     result
  #   end
  #   
  #   def render_haml(data, options, locals, &block)
  #     ::Haml::Engine.new(data, options).render(self, locals, &block)
  #   end
  #   
  #   def render_sass(data, options, locals, &block)
  #     ::Sass::Engine.new(data, options).render
  #   end
  #   
  #   def render_builder(data, options, locals, &block)
  #     options = { :indent => 2 }.merge(options)
  #     filename = options.delete(:filename) || '<BUILDER>'
  #     line = options.delete(:line) || 1
  #     xml = ::Builder::XmlMarkup.new(options)
  #     if data.respond_to?(:to_str)
  #       eval data.to_str, binding, filename, line
  #     elsif data.kind_of?(Proc)
  #       data.call(xml)
  #     end
  #     xml.target!
  #   end
  # 
  # end #/ module Templates
  
end #/module Sinatra 
