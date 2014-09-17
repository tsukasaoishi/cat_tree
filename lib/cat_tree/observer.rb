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

    def notice(object, options = {})
      case object
      when ActiveRecord::Base
        key = "#{object.class.name}_#{object.id}"
        @ar_base[key] += 1
      when ActiveRecord::Relation
        return if caller.detect{|c| c =~ /`build_default_scope'$/ }

        ids = [object.object_id, options[:source_id]].compact
        if key = @ar_relation.keys.detect{|k| (k - ids).size != k.size }
          val = @ar_relation.delete(key)
          key.concat(ids).uniq!
        else
          val = {}
          key = ids
        end
        
        @ar_relation[key] = val
        @ar_relation[key][:object] = object
        @ar_relation[key][:caller] = caller
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
