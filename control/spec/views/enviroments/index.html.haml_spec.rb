require 'rails_helper'

RSpec.describe "enviroments/index", type: :view do
  before(:each) do
    assign(:enviroments, [
      Enviroment.create!(
        :title => "Title"
      ),
      Enviroment.create!(
        :title => "Title"
      )
    ])
  end

  it "renders a list of enviroments" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
