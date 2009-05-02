begin
  require 'tenjin'

  module Slate
    class Tenjin < TemplateEngine
      ENGINE_MAPPING['tenjin'] = Tenjin

      def self.render_string(string, binding, options={})
        tenjin_options = {}
        tenjin_options[:escapefunc] = options[:escapefunc] if options.key? :escapefunc

        slug = [string, tenjin_options]

        result = compiled?(slug)
        if result.nil?
          result = compile(slug)
        end
        
        if options.key? :tenjin_context
          context = options[:tenjin_context]
        elsif !binding.nil?
          context = eval("self", binding)
        else
          context = ::Tenjin::Context.new
        end
        begin
          result.render(context)
        rescue NoMethodError => e
          if e.message =~ /_buf=/
            raise "Please include ::Tenjin::ContextHelper (and optionally ::Tenjin::HtmlHelper) in your controller/context (class of context is #{context.class.inspect})."
          end
          raise e
        end
      end

      def self.compile(slug, options={})
        result = ::Tenjin::Template.new(nil, slug[1])
        result.convert(slug[0])
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
