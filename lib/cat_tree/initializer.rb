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

      def cat_tree_notice(object, options = {})
        if cat_tree_observer = @@cat_tree_observer[Thread.current.object_id]
          cat_tree_observer.notice(object, options)
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

    module ArRelation
      def self.included(base)
        base.alias_method_chain :initialize, :cat_tree
        base.alias_method_chain :initialize_copy, :cat_tree
        base.alias_method_chain :exec_queries, :cat_tree
        base.extend CatTree::Initializer::ClassMethods
      end

      def initialize_with_cat_tree(*args)
        initialize_without_cat_tree(*args)
        self.class.cat_tree_notice(self)
      end

      def initialize_copy_with_cat_tree(other)
        initialize_copy_without_cat_tree(other)
        self.class.cat_tree_notice(self, :source_id => other.object_id)
      end

      private

      def exec_queries_with_cat_tree
        return @records if loaded?

        ret = exec_queries_without_cat_tree
        self.class.cat_tree_notice(self)
        ret
      end
    end

    def self.extend_active_record
      ActiveRecord::Base.__send__(:include, Initializer::ArBase)
      ActiveRecord::Relation.__send__(:include, Initializer::ArRelation)
    end
  end
end
