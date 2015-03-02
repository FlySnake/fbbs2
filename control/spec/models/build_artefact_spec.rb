require 'rails_helper'

RSpec.describe BuildArtefact, type: :model do
  it "has a valid factory" do
    expect(build(:build_artefact)).to be_valid
  end
end
