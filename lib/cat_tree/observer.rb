require 'active_record'
require 'cat_tree/logger'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @ar_base = []
      @ar_relation = {}
    end

    def notice(object, options = {})
      case object
      when ActiveRecord::Base
        notice_from_base(object, options)
      when ActiveRecord::Relation
        notice_from_relation(object, options)
      else
        raise ArgumentError, "unknown object : #{object.inspect}"
      end
    end

    def ar_base_count
      @ar_base.compact.size
    end

    def ar_relation_count
      @ar_relation.size
    end

    def unused_ar_relation_count
      @ar_relation.select{|k,v| !v[:object].loaded?}.size
    end

    def same_ar_base_objects
      result = Hash.new(0)
      @ar_base.compact.each do |object|
        key = "#{object.class.name}(id:#{object.id})"
        result[key] += 1
      end
      result.select{|k,v| v > 1}
    end

    def check
      ActiveRecord::Base.add_cat_tree_observer(self)
      yield
    ensure
      ActiveRecord::Base.remove_cat_tree_observer
      Logger.warn output_message
    end

    private

    def notice_from_base(object, options)
      @ar_base << object
    end

    def notice_from_relation(object, options)
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
    end

    def output_message
      msg = ["", "[CatTree]"]
      mas << "  ActiveRecord::Base:\t#{ar_base_count}"
      msg << "  ActiveRecord::Relation:\t#{ar_relation_count}"
      msg << "  Un-used ActiveRecord::Relation:\t#{unused_ar_relation_count}"

      unless (same_objects = same_ar_base_objects).empty?
        msg << "  Same objects:"
        same_objects.each do |obj, count|
          msg << "    #{obj}:\t#{count}"
        end
      end
      msg << ""

      msg.join("\n")
    end
  end
end
