begin
  require 'erb'

  module Slate
    class ERB < TemplateEngine
      ENGINE_MAPPING['erb'] = Slate::ERB
  
      def self.render_string(string, binding, options={})
        binding ||= Object.new

        result = compiled?(string)
        if result.nil?
          result = compile(string, options)
        end
        result.result(binding)
      end
    
      def self.compile(string, options={})
        result = ::ERB.new(string)
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