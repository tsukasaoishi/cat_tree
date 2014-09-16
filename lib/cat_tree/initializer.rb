module CatTree
  module Initializer
    module ArBase
      def self.included(base)
        base.after_initialize :cat_tree_count_up
        base.extend ClassMethods
      end

      private

      def cat_tree_count_up
        self.class.cat_tree_count_up(self)
      end

      module ClassMethods
        @@cat_tree_observer = {}

        def add_cat_tree_observer(observer)
          @@cat_tree_observer[Thread.current.object_id] = observer
        end

        def remove_cat_tree_observer
          @@cat_tree_observer[Thread.current.object_id] = nil
        end

        def cat_tree_count_up(object)
          if cat_tree_observer = @@cat_tree_observer[Thread.current.object_id]
            cat_tree_observer.count_up(object)
          end
        end
      end
    end

    def self.extend_active_record
      ActiveRecord::Base.__send__(:include, Initializer::ArBase)
    end
  end
end
