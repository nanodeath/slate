begin
  require 'builder'

  module Slate
    class Builder < TemplateEngine
      ENGINE_MAPPING['builder'] = Builder

      def self.render_block(binding, options={}, &block)
        builder_options = options.dup.delete_if {|k, v| ![:indent, :margin].include? k}
        #block.call(::Builder::XmlMarkup.new(builder_options))
        yield ::Builder::XmlMarkup.new(builder_options)
      end

      # no compile stage here
    end
  end
rescue LoadError
end