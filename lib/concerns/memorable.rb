module Memorable
  module InstanceMethods

    def initialize(name = nil)
      @id = self.class.count + 1
      self.class.all << self
      @name = name
    end
    
  end

  module ClassMethods

    def reset_all
      @all = []
    end

    def count
      @all.size
    end

    def all
      @all ||= []
    end

  end
end