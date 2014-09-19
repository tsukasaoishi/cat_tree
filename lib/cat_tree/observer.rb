require 'active_record'
require 'cat_tree/logger'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @ar_base = {}
    end

    def notice(object)
      return if object.new_record?
      key = {:model => object.class.name, :id => object.id}
      @ar_base[key] ||= {:count => 0, :callers => []}
      @ar_base[key][:count] += 1
      @ar_base[key][:callers] << caller
    end

    def ar_base_count
      @ar_base.values.inject(0){|t,v| t + v[:count]}
    end

    def same_ar_base_objects
      result = Hash.new(0)
      @ar_base.each do |key, value|
        key = "#{key[:model]}(id:#{key[:id]})"
        result[key] += value[:count]
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
        same_objects.keys.sort_by{|k| same_objects[k]}.reverse.each do |key|
          msg << "    #{key}:\t#{same_objects[key]}"
        end
      end
      msg << ""

      Logger.warn msg.join("\n")
    end
  end
end
