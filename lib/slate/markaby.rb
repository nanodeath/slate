begin
  require 'markaby'
  # TODO: Hmm, what about markaby tags?
  
  module Slate
    class Markaby < TemplateEngine
      ENGINE_MAPPING['markaby'] = Markaby

      def self.render_block(binding, options={}, &block)
        binding ||= Object.new
        ::Markaby::Builder.new(get_instance_variables_from(binding), nil, &block).to_s
      end

      # No compile step :( since the binding is taken in the constructor
    end
  end
rescue LoadError
end