begin
require 'liquid'

# TODO: Hmm, what about liquid tags?
module Slate
  class Liquid < TemplateEngine
    def self.render_string(string, binding, options={})
      binding ||= Object.new

      result = compiled?(string)
      if result.nil?
        result = compile(string, options)
      end
      instance_variables = {}
      eval("instance_variables", binding).each do |iv|
        iv = iv.to_s[1..-1]
        instance_variables[iv] = eval("@#{iv}", binding)
      end
      result.render(instance_variables)
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