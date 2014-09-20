require 'active_record'
require 'cat_tree/observer/target_set'
require 'cat_tree/logger'

module CatTree
  class Observer
    def self.check(&block)
      self.new.check(&block)
    end

    def initialize
      @target_set = TargetSet.new
    end

    def notice(object)
      @target_set.notice(object)
    end

    def ar_base_count
      @target_set.object_count
    end

    def same_ar_base_objects
      @target_set.same_objects
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
      return if @target_set.empty?

      msg = ["", "[CatTree]"]
      msg << "  ActiveRecord::Base:\t#{ar_base_count}"

      unless (same_objects = same_ar_base_objects).empty?
        msg << "  Same objects:"
        same_objects.each do |same_obj|
          msg << "    #{same_obj.title}:\t#{same_obj.count}"

          if Config.backtrace
            same_obj.callers.each do |cal|
              cal.each{|c| msg << "      #{c}"}
              msg << ""
            end
          end
        end
      end
      msg << ""

      Logger.warn msg.join("\n")
    end
  end
end
