require 'spec_helper'

describe CatTree::Observer do
  before do
    User.truncate
    Article.truncate

    u = User.create(:name => "cat_tree")
    u.articles.create(:title => "title1")
    u.articles.create(:title => "title2")
    u2 = User.create(:name => "cat_tree2")
    u2.articles.create(:title => "title3")
    @number_of_object = rand(10) + 1
  end

  context "#check" do
    it "count to create AR::Base object" do
      observer = CatTree::Observer.new
      observer.check do
        @number_of_object.times { User.new }
      end

      expect(observer.ar_base_count).to eq(@number_of_object)
    end

    it "count to find AR::Base object" do
      observer = CatTree::Observer.new
      observer.check do
        @number_of_object.times { User.where(:name => "cat_tree").first }
      end

      expect(observer.ar_base_count).to eq(@number_of_object)
    end

    it "count to find AR::Base object with association" do
      observer = CatTree::Observer.new
      observer.check do
        @number_of_object.times { User.includes(:articles).where(:name => "cat_tree").first }
      end

      expect(observer.ar_base_count).to eq(@number_of_object * 3)
    end

    it "count to create AR::Relation object" do
      observer = CatTree::Observer.new
      observer.check do
        @number_of_object.times { User.where(:name => "cat_tree").first }
      end

      expect(observer.ar_relation_count).to eq(@number_of_object)
    end

    it "count un-used AR::Relation object" do
      observer = CatTree::Observer.new
      observer.check do
        @number_of_object.times do
          User.where(:name => "cat_tree").first
          User.where(:name => "cat_tree").limit(1)
        end
      end

      expect(observer.unused_ar_relation_count).to eq(@number_of_object)
    end

    it "count same AR:Base object" do
      observer = CatTree::Observer.new
      observer.check do
        User.new
        User.create(:name => "dummy")
        @number_of_object.times do
          User.includes(:articles).where(:name => "cat_tree").first
        end
      end

      result = observer.same_ar_base_objects
      expect(result.size).to eq(3)
      result.each do |key, count|
        expect(["User(id:1)", "Article(id:1)", "Article(id:2)"]).to include(key)
        expect(count).to eq(@number_of_object)
      end
    end
  end
end
