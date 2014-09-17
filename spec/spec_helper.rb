ENV["RAILS_ENV"]="test"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'logger'
require 'cat_tree'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'cat_tree_test.sqlite3'),
  :pool =>  5,
  :timeout => 5000
)

module TruncateTable
  def truncate
    delete_all
    connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = '#{table_name}'")
  end
end

class User < ActiveRecord::Base
  extend TruncateTable
  has_many :articles
end

class Article < ActiveRecord::Base
  extend TruncateTable
  belongs_to :user
end

CatTree::Initializer.extend_active_record
