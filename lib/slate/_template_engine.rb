module Slate
  class TemplateEngine
    @cache = Slate::Cache.new
#    @extensions = {}
    class << self
      attr_reader :extensions
    end

    def self.compiled?(string)
      @cache ||= Slate::Cache.new
      @cache[string]
    end
    
    def self.clear_cache
      if @cache
        @cache.clear
      else
        @cache = Cache.new
      end
    end

    def self.get_instance_variables_from(binding)
      instance_variables = {}
      eval("instance_variables", binding).each do |iv|
        iv = iv.to_s[1..-1]
        instance_variables[iv] = eval("@#{iv}", binding)
      end
      return instance_variables
    end

    def self.register_extension(ext, klass, precedence=:low_precedence)
      ((@extensions ||= {})[ext] ||= []) << klass

    end
  end
end