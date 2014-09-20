module CatTree
  class Observer
    class ArBase
      attr_reader :count, :callers

      def initialize(object)
        return unless object_valid?(object)
        @valid = true

        @model = object.class.name
        @model_id = object.id
        @count = 1
        @callers = []

        record_backtrace if CatTree::Config.backtrace
      end

      def merge(other)
        @count += other.count
        @callers.concat(other.callers)
        self
      end

      def ==(other)
        key == other.key
      end

      def key
        [@model, @model_id]
      end

      def valid?
        !!@valid
      end

      def title
        "#{@model}(id:#{@model_id})"
      end

      private

      def object_valid?(object)
        object.is_a?(ActiveRecord::Base) && !object.new_record?
      end

      def record_backtrace
        @callers << (defined?(Rails) ? backtrace_in_rails : caller)
      end

      def backtrace_in_rails
        root_path = Rails.root.to_s
        root_path += "/" unless root_path.last == "/"
        caller.select{|c| c =~ %r!#{root_path}(app|lib)/!}
      end
    end
  end
end

