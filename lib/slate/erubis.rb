begin
  require 'erubis'

  module Slate
    class Erubis < TemplateEngine
      ENGINE_MAPPING['erubis'] = Erubis
      DEFAULT_OPTIONS = {:engine => ::Erubis::Eruby}
  
      def self.render_string(string, context, options={})
        context ||= {}
        options = DEFAULT_OPTIONS.dup.merge(options)
        slug = [string, options[:engine], options[:erubis_options]]

        result = compiled?(slug)
        if result.nil?
          result = compile(slug, options)
        end
        if context.is_a? Binding
          context = get_instance_variables_from(context)
        end

        # #result only offers a 4x speedup w/ caching, vs. a 10x speedup w/ #evaluate
        # result.result(binding)
        result.evaluate(context)
      end
    
      def self.compile(slug, options={})
        result = slug[1].new(slug[0], slug[2] || {})
        if(!options[:no_cache])
          @cache ||= Cache.new
          @cache[slug] = result
        end
        result
      end
    end
  end
rescue LoadError
end