begin
  require 'tenjin'

  module Slate
    class Tenjin < TemplateEngine
      ENGINE_MAPPING['tenjin'] = Tenjin

      def self.render_string(string, binding, options={})
        result = compiled?(string)
        if result.nil?
          result = compile(string, options)
        end
        context = ::Tenjin::Context.new(get_instance_variables_from(binding))
        result.render(context)
      end

      def self.compile(string, options={})
        result = ::Tenjin::Template.new
        result.convert(string)
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