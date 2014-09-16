require 'spec_helper'

describe CatTree do
  context "VERSION" do
    it "return 0.0.1" do
      expect(CatTree::VERSION).to eq "0.0.1"
    end
  end
end
