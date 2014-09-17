require 'spec_helper'

describe CatTree::Observer do
  before do
    User.truncate
    Article.truncate
  end

  context "#check" do
    it "check count to create AR::Base object" do
      number_of_object = 1#rand(10) + 1
      observer = CatTree::Observer.new
      observer.check do
        number_of_object.times { User.new }
      end

      expect(observer.count).to eq(number_of_object)
    end

    it "check count to find AR::Base object" do
      number_of_object = 1#rand(10) + 1
      User.create(:name => "cat_tree")

      observer = CatTree::Observer.new
      observer.check do
        a = User.where(:name => "cat_tree")
        number_of_object.times { User.where(:name => "cat_tree").first }
      end

      expect(observer.count).to eq(number_of_object)
    end
  end
end
