begin
  require 'liquid'

  # TODO: Hmm, what about liquid tags?
  module Slate
    class Liquid < TemplateEngine
      ENGINE_MAPPING['liquid'] = Liquid

      def self.render_string(string, binding, options={})
        binding ||= Object.new

        result = compiled?(string)
        if result.nil?
          result = compile(string, options)
        end
        result.render(get_instance_variables_from(binding))
      end
    
      def self.compile(string, options={})
        result = ::Liquid::Template.parse(string)
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