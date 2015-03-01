require 'rails_helper'

RSpec.describe Branch, type: :model do
  it 'filters all branches' do
    names = ["master", "release_36", "release_37", "release_38_tests", "12345_feature_34", "12345_feature_35", 
      "57845_feature_40", "master1", "masterhjgd", "124master", "master_tesing"]
    names.each do |name|
      Branch.create(:name => name)
    end
    expect(Branch.all_filtered("").to_a.map {|b| b.name}).to match_array names
  end
  
  it 'filters branches with regex' do
    names = ["master", "release_36", "release_37", "release_38_tests", "12345_feature_34", "12345_feature_35", 
      "57845_feature_40", "master1", "masterhjgd", "124master", "master_tesing"]
    names.each do |name|
      Branch.create(:name => name)
    end
    expect(Branch.all_filtered(/(release|master)/).to_a.map {|b| b.name}).to match_array ["master", "release_36", 
      "release_37", "release_38_tests", "master1", "masterhjgd", "124master", "master_tesing"]
  end
  
end
