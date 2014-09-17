require "cat_tree/rack"
require "cat_tree/initializer"
require "cat_tree/logger"
require 'rails'

module CatTree
  class Railtie < Rails::Railtie
    initializer "cat_tree.configure_rails_initialization" do |app|
      app.config.app_middleware.add  CatTree::Rack
      CatTree::Logger.logger = Rails.logger

      ActiveSupport.on_load(:active_record) do
        Initializer.extend_active_record
      end
    end
  end
end
