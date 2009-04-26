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


    def self.get_instance_variables_from(binding)
      instance_variables = {}
      eval("instance_variables", binding).each do |iv|
        iv = iv.to_s[1..-1]
        instance_variables[iv] = eval("@#{iv}", binding)
      end
      return instance_variables
    end

    def self.execute_method_on(binding, meth, args)
      attributes = []
      1.upto(args.length) {|i| attributes << "var#{i}"} 

      st = Struct.new("SlateTmpVar", *attributes).new

      target_inst = eval('self', binding)

      i = 0
      begin
        method = "__tmp_slate_#{meth}_#{i += 1}"
      end while target_inst.respond_to? method.to_sym
      

      begin
        raise
        target_inst.instance_eval { attr_accessor method }
      rescue
        target_inst.instance_eval "def #{method}; @#{method}; end"
        target_inst.instance_eval "def #{method}=(val); @#{method}=val; end"
      end

      i = 0
      eval_args = []
      args.each do |a|
        i += 1
        st["var#{i}"] = a
        eval_args << "#{method}['var#{i}']"
      end

      target_inst.send "#{method}=", st

      eval_string = "%s(%s)" % [meth, eval_args.join(",")]
      eval(eval_string, binding)
    end
  end
end