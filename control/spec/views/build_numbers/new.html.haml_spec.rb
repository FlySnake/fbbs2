require 'rails_helper'

RSpec.describe "build_numbers/new", type: :view do
  before(:each) do
    assign(:build_number, BuildNumber.new(
      :branch => "MyString",
      :commit => "MyString",
      :number => "MyString"
    ))
  end

  it "renders new build_number form" do
    render

    assert_select "form[action=?][method=?]", build_numbers_path, "post" do

      assert_select "input#build_number_branch[name=?]", "build_number[branch]"

      assert_select "input#build_number_commit[name=?]", "build_number[commit]"

      assert_select "input#build_number_number[name=?]", "build_number[number]"
    end
  end
end
