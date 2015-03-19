require 'rails_helper'

RSpec.describe TargetPlatform, type: :model do
  it "has a valid factory" do
    expect(build(:target_platform)).to be_valid
  end
  
  describe "ordering by mask" do
    it "returns all without mask given" do
      create(:target_platform)
      create(:target_platform)
      create(:target_platform)
      expect(TargetPlatform.all_ordered_by_mask(nil).length).to eq 3
    end
    
    it "returns all with empty mask given" do
      create(:target_platform)
      create(:target_platform)
      create(:target_platform)
      expect(TargetPlatform.all_ordered_by_mask([]).length).to eq 3
    end
    
    it "returns ordered by mask objects" do
      other = create(:target_platform, :title => "other")
      android = create(:target_platform, :title => "android")
      windows = create(:target_platform, :title => "windows")
      posix = create(:target_platform, :title => "posix")
      expect(TargetPlatform.all_ordered_by_mask(["windows", "posix", "android"])).to eq [windows, posix, android, other]
    end
    
    it "returns ordered by mask objects #2" do
      other = create(:target_platform, :title => "other")
      android = create(:target_platform, :title => "android")
      windows = create(:target_platform, :title => "windows")
      posix = create(:target_platform, :title => "posix")
      expect(TargetPlatform.all_ordered_by_mask(["android"]).first).to eq android
    end
    
    it "returns ordered by mask objects with all objects" do
      other = create(:target_platform, :title => "other")
      android = create(:target_platform, :title => "android")
      windows = create(:target_platform, :title => "windows")
      posix = create(:target_platform, :title => "posix")
      expect(TargetPlatform.all_ordered_by_mask(["android"]).length).to eq 4
    end
    
  end
  
end
