require 'rails_helper'

RSpec.describe BaseVersion, type: :model do
  it "has a valid factory" do
    expect(build(:base_version)).to be_valid
  end

  it 'is valid with name' do
    base_version = build(:base_version, :name => Faker::Lorem.characters(2))
    expect(base_version).to be_valid
  end
  
  it 'is invalid without name' do
    base_version = build(:base_version, :name => nil)
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with to short name' do
    base_version = build(:base_version, :name => Faker::Lorem.characters(0))
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with to long name' do
    base_version = build(:base_version, :name => Faker::Lorem.characters(102))
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with duplicate name' do
    FactoryGirl.create(:base_version, :name => "4.1")
    base_version = build(:base_version, :name => "4.1")
    expect(base_version).to be_invalid
  end
  
end
