require 'rails_helper'

RSpec.describe "Badges", type: :request do
  describe "GET /count" do
    it "returns http success" do
      get "/badges/count"
      expect(response).to have_http_status(:success)
    end
  end

end
