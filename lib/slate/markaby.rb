begin
require 'markaby'

# TODO: Hmm, what about liquid tags?
module Slate
  class Markaby < TemplateEngine
    ENGINE_MAPPING['markaby'] = Markaby

    def self.render_block(binding, options={}, &block)
      binding ||= Object.new
      ::Markaby::Builder.new(get_instance_variables_from(binding), nil, &block).to_s
    end
  end
end
rescue LoadError
end