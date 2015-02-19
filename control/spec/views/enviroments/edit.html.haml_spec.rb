require 'rails_helper'

RSpec.describe "enviroments/edit", type: :view do
  before(:each) do
    @enviroment = assign(:enviroment, Enviroment.create!(
      :title => "MyString"
    ))
  end

  it "renders the edit enviroment form" do
    render

    assert_select "form[action=?][method=?]", enviroment_path(@enviroment), "post" do

      assert_select "input#enviroment_title[name=?]", "enviroment[title]"
    end
  end
end
