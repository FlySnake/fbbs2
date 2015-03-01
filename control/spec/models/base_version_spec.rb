require 'rails_helper'

RSpec.describe BaseVersion, type: :model do
  it 'is valid with name' do
    base_version = BaseVersion.new(:name => "3.0")
    expect(base_version).to be_valid
  end
  
  it 'is invalid without name' do
    base_version = BaseVersion.new(:name => nil)
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with to short name' do
    base_version = BaseVersion.new(:name => "")
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with to long name' do
    base_version = BaseVersion.new(:name => "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789")
    expect(base_version).to be_invalid
  end
  
  it 'is invalid with duplicate name' do
    BaseVersion.create(:name => "4.1")
    base_version = BaseVersion.new(:name => "4.1")
    expect(base_version).to be_invalid
  end
  
end
