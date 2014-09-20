require 'cat_tree/observer/target_set/ar_base'

module CatTree
  class Observer
    class TargetSet
      def initialize
        @set = {}
      end

      def notice(object)
        return unless target = get_target(object)
        return unless target.valid?

        if same_target = @set[target.key]
          @set[target.key] = same_target.merge(target)
        else
          @set[target.key] = target
        end
      end

      def object_count
        @set.values.inject(0){|t,v| t + v.count}
      end

      def same_objects
        @set.values.select{|v| v.count > 1}.sort_by{|v| v.count}.reverse
      end

      def empty?
        @set.empty?
      end

      private

      def get_target(object)
        case object
        when ActiveRecord::Base
          ArBase.new(object)
        end
      end
    end
  end
end
