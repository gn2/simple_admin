require 'singleton'

module SimpleAdmin
  
  class Tabs
    include Singleton
    
    def initialize
      @list = []
    end
    
    def register(name, path)
      @list << {:name => name, :path => path}
    end
    
    def list
      @list
    end
    
    def ordered_list
      @list.sort {|a,b| a[:name].to_s <=> b[:name].to_s}
    end
    
  end
  
end