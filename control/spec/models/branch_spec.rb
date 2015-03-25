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
      it 'filters branches with regex #1' do
        @branches_names.each do |name|
          create(:branch, :name => name)
        end
        expect(Branch.all_filtered(/(release|master)/).to_a.map {|b| b.name}).to match_array ["master", "release_36", 
          "release_37", "release_38_tests", "master1", "masterhjgd", "124master", "master_tesing"]
      end
      
      it 'filters branches with regex #2' do
        @branches_names.each do |name|
          create(:branch, :name => name)
        end
        expect(Branch.all_filtered(/^(release_|master$)/).to_a.map {|b| b.name}).to match_array ["master", "release_36", 
          "release_37", "release_38_tests"]
      end      
    end
    
  end
  
  describe "soft deletion" do
    it "is not really destroyed from the database after calling destroy" do
      b = create(:branch)
      b.destroy
      b.reload
      expect{ Branch.find(b.id) }.not_to raise_error
    end
    
    it "is marked as deleted after destoy call" do
      b = create(:branch)
      b.destroy
      b.reload
      expect(b.deleted_at).not_to eq nil
    end
    
    it "is 'destoyed?' after destroy call" do
      b = create(:branch)
      b.destroy
      b.reload
      expect(b.destroyed?).to eq true
    end
    
  end
  
end
