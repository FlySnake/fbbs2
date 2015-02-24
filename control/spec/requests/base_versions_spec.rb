require 'rails_helper'

RSpec.describe "BaseVersions", type: :request do
  describe "GET /base_versions" do
    it "works! (now write some real specs)" do
      get base_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
