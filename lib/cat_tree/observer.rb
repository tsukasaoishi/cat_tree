require 'active_record'
require 'cat_tree/logger'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @ar_base = []
    end

    def notice(object)
      @ar_base << object
    end

    def ar_base_count
      @ar_base.compact.size
    end

    def same_ar_base_objects
      result = Hash.new(0)
      @ar_base.compact.each do |object|
        key = "#{object.class.name}(id:#{object.id})"
        result[key] += 1
      end
      Hash[*(result.select{|k,v| v > 1}.flatten)]
    end

    def check
      ActiveRecord::Base.add_cat_tree_observer(self)
      yield
    ensure
      ActiveRecord::Base.remove_cat_tree_observer
      output_message
    end

    private

    def output_message
      return if @ar_base.empty? && @ar_relation.empty?

      msg = ["", "[CatTree]"]
      msg << "  ActiveRecord::Base:\t#{ar_base_count}"

      unless (same_objects = same_ar_base_objects).empty?
        msg << "  Same objects:"
        same_objects.keys.sort_by{|k| same_objects[k]}.reverse.each do |obj|
          msg << "    #{obj}:\t#{same_objects[obj]}"
        end
      end
      msg << ""

      Logger.warn msg.join("\n")
    end
  end
end
