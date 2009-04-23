module Slate
  class TemplateEngine
    def self.compiled?(string)
      @cache ||= Cache.new
      @cache.key? string
    end
    
    def self.clear_cache
      if @cache
        @cache.clear
      else
        @cache = Cache.new
      end
    end
  
  end
end