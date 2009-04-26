begin
  require 'erector'

  module Slate
    class Erector < TemplateEngine
      ENGINE_MAPPING['erector'] = Erector

      def self.render_block(binding, options={}, &block)
        if block_given?
          ::Erector::Widget.new(options[:helpers], options[:assigns] || {}, options[:output] || '', &block).to_s
        else
          klass = options[:class] or raise "No class provided for Erector"
          options.key?(:method) ? klass.new.to_s(options[:method]) : klass.new.to_s
        end
      end

      # No compile step :( since the binding is taken in the constructor
    end
  end
rescue LoadError
end