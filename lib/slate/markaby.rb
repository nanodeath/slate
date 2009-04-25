begin
  require 'markaby'

  module Slate
    class Markaby < TemplateEngine
      ENGINE_MAPPING['markaby'] = Markaby

      def self.render_block(binding, options={}, &block)
        binding ||= Object.new
        if(options[:only_assigns])
          iv = options[:assigns] || {}
        else
          iv = get_instance_variables_from(binding).merge(options[:assigns] || {})
        end
        
        
        helpers = options[:helpers]
        puts "Helpers is #{helpers.inspect}"
        ::Markaby::Builder.new(iv, helpers, &block).to_s
      end

      # No compile step :( since the binding is taken in the constructor
    end
  end
rescue LoadError
end