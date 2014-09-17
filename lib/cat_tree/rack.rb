require 'cat_tree/observer'

module CatTree
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      Observer.check do
        @app.call(env)
      end
    end
  end
end
