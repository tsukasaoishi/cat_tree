ENV["RAILS_ENV"]="test"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cat_tree'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'cat_tree_test.sqlite3'),
  :pool =>  5,
  :timeout => 5000
)

class User < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :user
end

CatTree::Initializer.extend_active_record
