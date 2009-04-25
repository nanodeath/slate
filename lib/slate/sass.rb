begin
  require 'haml/util'
  require 'sass/engine'

  module Slate
    class Sass < TemplateEngine
      ENGINE_MAPPING['sass'] = Sass
  
      def self.render_string(string, binding, options={})
        result = compiled?(string)
        if result.nil?
          result = compile(string, options)
        end
        result
      end
    
      def self.compile(string, options={})
        result = ::Sass::Engine.new(string).to_css
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