require 'haml/util'
require 'haml/engine'
module Slate
  class Haml < TemplateEngine
    def self.render_string(string, binding, options={})
      binding ||= Object.new

      if compiled?(string)
        result = @cache[string]
      else
        result = compile(string, options)
      end
      result.render(binding)
    end
    
    def self.compile(string, options={})
      result = ::Haml::Engine.new(string)
      if(!options[:no_cache])
        @cache ||= Cache.new
        @cache[string] = result
      end
      result
    end
  end
end