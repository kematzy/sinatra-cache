
# :stopdoc:
unless Object.new.respond_to?(:blank?)
  
  class Object
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
    def present?
      !blank?
    end
  end
end
# :startdoc:


module Sinatra
  
  # Sinatra::Output Extension
  # 
  # Provides support for the :cache_fragment() functionality.
  # 
  # Thank You very much Nathan. Much appreciated!
  # 
  # 
  # The code within this extension is almost in its interity copied from:
  # 
  #   sinatra_more gem [ http://github.com/nesquena/sinatra_more/ ] by Nathan Esquenazi.
  # 
  # 
  # Copyright (c) 2009 Nathan Esquenazi
  # 
  # Permission is hereby granted, free of charge, to any person obtaining
  # a copy of this software and associated documentation files (the
  # "Software"), to deal in the Software without restriction, including
  # without limitation the rights to use, copy, modify, merge, publish,
  # distribute, sublicense, and/or sell copies of the Software, and to
  # permit persons to whom the Software is furnished to do so, subject to
  # the following conditions:
  # 
  # The above copyright notice and this permission notice shall be
  # included in all copies or substantial portions of the Software.
  # 
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  # OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  # WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  # 
  # 
  module Output
    
    VERSION = Sinatra::Cache::VERSION
    ##
    # Returns the version string for this extension
    # 
    # ==== Examples
    # 
    #   Sinatra::Output.version  => 'Sinatra::Output v0.9.9'
    # 
    def self.version; "Sinatra::Output v#{VERSION}"; end
    
    
    module Helpers
      
      # Captures the html from a block of template code for erb or haml
      # capture_html(&block) => "...html..."
      def capture_html(*args, &block)
        if self.respond_to?(:is_haml?) && is_haml?
           block_is_haml?(block) ? capture_haml(*args, &block) : block.call
        elsif has_erb_buffer?
          result_text = capture_erb(*args, &block)
          result_text.present? ? result_text : (block_given? && block.call(*args))
        else # theres no template to capture, invoke the block directly
          block.call(*args)
        end
      end
      
      # Outputs the given text to the templates buffer directly
      # concat_content("This will be output to the template buffer in erb or haml")
      def concat_content(text="") 
        if self.respond_to?(:is_haml?) && is_haml?
          haml_concat(text)
        elsif has_erb_buffer?
          erb_concat(text)
        else # theres no template to concat, return the text directly
          text
        end
      end
      
      # Returns true if the block is from an ERB or HAML template; false otherwise.
      # Used to determine if html should be returned or concatted to view
      # block_is_template?(block)
      def block_is_template?(block) 
         block && (block_is_erb?(block) || (self.respond_to?(:block_is_haml?) && block_is_haml?(block)))
      end
      
      
      protected
        
        # Used to capture the html from a block of erb code
        # capture_erb(&block) => '...html...'
        def capture_erb(*args, &block) 
          erb_with_output_buffer { block_given? && block.call(*args) }
        end
        
        # Concats directly to an erb template
        # erb_concat("Direct to buffer")
        def erb_concat(text) 
          @_out_buf << text if has_erb_buffer?
        end
        
        # Returns true if an erb buffer is detected
        # has_erb_buffer? => true
        def has_erb_buffer? 
          !@_out_buf.nil?
        end
        
        # Used to determine if a block is called from ERB.
        # NOTE: This doesn't actually work yet because the variable __in_erb_template 
        # hasn't been defined in ERB. We need to find a way to fix this.
        def block_is_erb?(block) 
          has_erb_buffer? || block && eval('defined? __in_erb_template', block)
        end
        
        # Used to direct the buffer for the erb capture
        def erb_with_output_buffer(buf = '') #:nodoc: 
          @_out_buf, old_buffer = buf, @_out_buf
          yield
          @_out_buf
        ensure
          @_out_buf = old_buffer
        end
        
    end #/ Helpers
    
    # def self.registered(app)
    #   app.helpers Sinatra::Output::Helpers
    # end #/ self.registered
    
  end #/ Output
  
  helpers Sinatra::Output::Helpers
  
end #/ Sinatra
