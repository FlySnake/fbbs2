require 'rails_helper'

RSpec.describe "enviroments/show", type: :view do
  before(:each) do
    @enviroment = assign(:enviroment, Enviroment.create!(
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
