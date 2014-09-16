require 'active_record'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @ar_base = Hash.new(0)
      @ar_relation = {}
    end

    def count_up(object)
      case object
      when ActiveRecord::Base
        key = "#{object.class.name}_#{object.id}"
        @ar_base[key] += 1
      when ActiveRecord::Relation
        @ar_relation[object.to_sql] ||= {}
        @ar_relation[object.to_sql][:count] ||= 0
        @ar_relation[object.to_sql][:count] += 1
        @ar_relation[object.to_sql][:loaded] = object.loaded?
      else
        raise ArgumentError, "unknown object : #{object.inspect}"
      end
    end

    def count
      @ar_base.values.inject(0){|t,c| t + c}
    end

    def check
      ActiveRecord::Base.add_cat_tree_observer(self)
      yield
    ensure
      ActiveRecord::Base.remove_cat_tree_observer
    end
  end
end
