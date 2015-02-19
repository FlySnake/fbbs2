require 'rails_helper'

RSpec.describe "enviroments/new", type: :view do
  before(:each) do
    assign(:enviroment, Enviroment.new(
      :title => "MyString"
    ))
  end

  it "renders new enviroment form" do
    render

    assert_select "form[action=?][method=?]", enviroments_path, "post" do

      assert_select "input#enviroment_title[name=?]", "enviroment[title]"
    end
  end
end
