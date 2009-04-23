module Slate  
  class Cache < Hash
    attr_reader :total_size
    
    def initialize(*args)
      super
      @total_size = 0
    end
    
    def []=(key, value)
      if key? key
        @total_size -= key.to_s.length - self[key].to_s.length
      end
      super
      @total_size += key.to_s.length + value.to_s.length
    end      
    
    def clear
      super
      @total_size = 0
    end
    
    def delete(key)
      @total_size -= key.to_s.length - self[key].to_s.length
      super
    end      
  end
end