require 'rails_helper'

RSpec.describe "Enviroments", type: :request do
  describe "GET /enviroments" do
    it "works! (now write some real specs)" do
      get enviroments_path
      expect(response).to have_http_status(200)
    end
  end
end
