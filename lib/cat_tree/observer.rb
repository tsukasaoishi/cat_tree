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
      key = "#{object.class.name}(id:#{object.id})"
      @ar_base[key] ||= {:count => 0, :callers => []}
      @ar_base[key][:count] += 1
      if defined?(Rails)
        root_path = Rails.root.to_s
        root_path += "/" unless root_path.last == "/"
        cal = caller.select{|c| c =~ %r!#{root_path}(app|lib)/!}
        @ar_base[key][:callers] << cal unless cal.empty?
      else
        @ar_base[key][:callers] << caller
      end
    end

    def ar_base_count
      @ar_base.values.inject(0){|t,v| t + v[:count]}
    end

    def same_ar_base_objects
      Hash[*(@ar_base.select{|k,v| v[:count] > 1}.flatten)]
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
      return if @ar_base.empty?

      msg = ["", "[CatTree]"]
      msg << "  ActiveRecord::Base:\t#{ar_base_count}"

      unless (same_objects = same_ar_base_objects).empty?
        msg << "  Same objects:"
        same_objects.keys.sort_by{|k| same_objects[k][:count]}.reverse.each do |key|
          msg << "    #{key}:\t#{same_objects[key][:count]}"
          same_objects[key][:callers].each do |cal|
            cal.each{|c| msg << "      #{c}"}
            msg << ""
          end
        end
      end
      msg << ""

      Logger.warn msg.join("\n")
    end
  end
end
