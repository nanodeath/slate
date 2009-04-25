begin

require 'maruku'
module Slate
  class Maruku < TemplateEngine
    ENGINE_MAPPING['maruku'] = Maruku
    
    def self.render_string(string, binding, options={})
      result = compiled?(string)
      if result.nil?
        result = compile(string, options)
      end
      result
    end
    
    def self.compile(string, options={})
      result = ::Maruku.new(string).to_html_document
      if(!options[:no_cache])
        @cache ||= Cache.new
        @cache[string] = result
      end
      result
    end
  end
end

rescue LoadError
end