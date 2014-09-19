ENV["RAILS_ENV"]="test"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'logger'
require 'cat_tree'
require File.join(File.dirname(__FILE__), "prepare.rb")

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql2',
  :encoding => 'utf8',
  :reconnect => false,
  :database => 'cat_tree_test',
  :username => 'root',
  :pool =>  5,
  :timeout => 5000
)

module TruncateTable
  def truncate
    connection.execute("TRUNCATE TABLE #{table_name}")
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
