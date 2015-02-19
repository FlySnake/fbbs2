require 'rails_helper'

RSpec.describe "BuildNumbers", type: :request do
  describe "GET /build_numbers" do
    it "works! (now write some real specs)" do
      get build_numbers_path
      expect(response).to have_http_status(200)
    end
  end
end
