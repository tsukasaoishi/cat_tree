module CatTree
  module Initializer
    module ClassMethods
      @@cat_tree_observer = {}

      def add_cat_tree_observer(observer)
        @@cat_tree_observer[Thread.current.object_id] = observer
      end

      def remove_cat_tree_observer
        @@cat_tree_observer[Thread.current.object_id] = nil
      end

      def cat_tree_notice(object)
        if cat_tree_observer = @@cat_tree_observer[Thread.current.object_id]
          cat_tree_observer.notice(object)
        end
      end
    end

    module ArBase
      def self.included(base)
        base.after_initialize :cat_tree_notice
        base.extend CatTree::Initializer::ClassMethods
      end

      private

      def cat_tree_notice
        self.class.cat_tree_notice(self)
      end
    end

    def self.extend_active_record
      ActiveRecord::Base.__send__(:include, Initializer::ArBase)
    end
  end
end
