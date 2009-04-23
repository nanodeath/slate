require 'erubis'

module Slate
  class Erubis < TemplateEngine
    def self.render_string(string, binding, options={})
      binding ||= Object.new

      if compiled?(string)
        result = @cache[string]
      else
        result = compile(string, options)
      end
      result.result(binding)
    end
    
    def self.compile(string, options={})
      result = ::Erubis::Eruby.new(string)
      if(!options[:no_cache])
        @cache ||= Cache.new
        @cache[string] = result
      end
      result
    end
  end
end