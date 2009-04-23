require 'haml/util'
require 'haml/engine'
module Slate
  class Haml
    def self.render_string(string, binding, options={})
      if(!binding)
#         puts "oops, binding not set"
      end
      binding ||= Object.new
      
      if compiled?(string)
        result = @cache[string]
      else
        result = compile(string, options)
      end
      result.render(binding)
    end
    
    def self.compile(string, options={})
      evict_chance = options[:evict_chance] || 0

      result = ::Haml::Engine.new(string)
      if(!options[:no_cache])
        @cache ||= {}
        @cache[string] = result
      end
      if(evict_chance > 0)
      
      end
      result
    end
    
    def self.compiled?(string)
      @cache ||= {}
      @cache.key? string
    end
    
    def self.clear_cache
      @cache = {}
    end
  end
end