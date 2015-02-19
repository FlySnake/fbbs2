require 'rails_helper'

RSpec.describe "build_numbers/edit", type: :view do
  before(:each) do
    @build_number = assign(:build_number, BuildNumber.create!(
      :branch => "MyString",
      :commit => "MyString",
      :number => "MyString"
    ))
  end

  it "renders the edit build_number form" do
    render

    assert_select "form[action=?][method=?]", build_number_path(@build_number), "post" do

      assert_select "input#build_number_branch[name=?]", "build_number[branch]"

      assert_select "input#build_number_commit[name=?]", "build_number[commit]"

      assert_select "input#build_number_number[name=?]", "build_number[number]"
    end
  end
end
