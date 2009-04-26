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
        
        if !options.key? :tenjin_context
          target = eval("self", binding)
          unless target.respond_to? :start_capture
            target.class.instance_eval { include ::Tenjin::ContextHelper; include ::Tenjin::HtmlHelper; }
          end
          context = target
        else
          context = options[:tenjin_context]
        end
        result.render(context)
      end

      def self.compile(slug, options={})
        result = ::Tenjin::Template.new(nil, slug.last)
        result.convert(slug.first)
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
