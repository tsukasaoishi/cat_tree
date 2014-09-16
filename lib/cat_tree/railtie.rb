require "cat_tree/rack"
require "cat_tree/initializer"
require 'railse'

module CatTree
  class Railtie < Rails::Railtie
    initializer "cat_tree.configure_rails_initialization" do |app|
      ActiveSupport.on_load(:active_record) do
        app.config.app_middleware.add  CatTree::Rack
        Initializer.extend_active_record
      end
    end
  end
end
