module Slate
  class TemplateEngine
    def self.compiled?(string)
      @cache ||= Cache.new
      @cache[string]
    end
    
    def self.clear_cache
      if @cache
        @cache.clear
      else
        @cache = Cache.new
      end
    end
    protected
    def self.get_instance_variables_from(binding)
      instance_variables = {}
      eval("instance_variables", binding).each do |iv|
        iv = iv.to_s[1..-1]
        instance_variables[iv] = eval("@#{iv}", binding)
      end
      return instance_variables
    end
  end
end