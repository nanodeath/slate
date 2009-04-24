begin
require 'RedCloth'

module Slate
  class RedCloth < TemplateEngine
    def self.render_string(string, binding, options={})
      result = compiled?(string)
      if result.nil?
        result = compile(string, options)
      end
      result
    end
    
    def self.compile(string, options={})
      result = ::RedCloth.new(string).to_html
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