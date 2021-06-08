require 'rails_helper'

RSpec.describe "SupplierManagers::SupplierManagers", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/supplier_managers/supplier_managers/top"
      expect(response).to have_http_status(:success)
    end
  end

end
