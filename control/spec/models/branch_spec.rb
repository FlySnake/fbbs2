require 'rails_helper'

RSpec.describe Branch, type: :model do
  it "has a valid factory" do
    expect(build(:branch)).to be_valid
  end
  
  describe "filter branches by regex" do
    before :each do
      @branches_names = ["master", "release_36", "release_37", "release_38_tests", "12345_feature_34", "12345_feature_35", 
          "57845_feature_40", "master1", "masterhjgd", "124master", "master_tesing"]
    end
        
    context 'all branches withot filtering' do
      it 'filters all branches' do
        @branches_names.each do |name|
          create(:branch, :name => name)
        end
        expect(Branch.all_filtered("").to_a.map {|b| b.name}).to match_array @branches_names
      end
    end
      
    context 'with real regex' do
      it 'filters branches with regex' do
        @branches_names.each do |name|
          create(:branch, :name => name)
        end
        expect(Branch.all_filtered(/(release|master)/).to_a.map {|b| b.name}).to match_array ["master", "release_36", 
          "release_37", "release_38_tests", "master1", "masterhjgd", "124master", "master_tesing"]
      end
    end
  end
  
end
