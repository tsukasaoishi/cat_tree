require 'active_record'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @object_count = Hash.new(0)
    end

    def count_up(object)
      key = "#{object.class.name}_#{object.id}"
      @object_count[key] += 1
    end

    def count
      @object_count.values.inject(0){|t,c| t + c}
    end

    def check
      ActiveRecord::Base.add_cat_tree_observer(self)
      yield
    ensure
      ActiveRecord::Base.remove_cat_tree_observer
    end
  end
end
