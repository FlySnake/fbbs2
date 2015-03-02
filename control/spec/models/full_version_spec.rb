require 'rails_helper'

RSpec.describe FullVersion, type: :model do
  it "has a valid factory" do
    expect(build(:full_version)).to be_valid
  end
  
  it "assembles correct version without release" do
    base_version = build(:base_version, :name => "3.1")
    build_number = build(:build_number, :number => 12345)
    full_version = build(:full_version, :base_version => base_version, :build_number => build_number, :release_version => nil)
    expect(full_version.assemble).to eq "3.1.12345"
  end
  
  it "assembles correct version with release" do
    base_version = build(:base_version, :name => "3.1")
    build_number = build(:build_number, :number => 12345)
    release_version = build(:release_version, :name => "blablabla")
    full_version = build(:full_version, :base_version => base_version, :build_number => build_number, :release_version => release_version)
    expect(full_version.assemble).to eq "3.1.blablabla.12345"
  end
  
end
