require 'rails_helper'

RSpec.describe "管理者ログイン機能", type: :system do
  before do
    @admin = Admin.first
  end
  it "ログインが出来る" do
    visit root_url
    find(".to-login-btn").click
    fill_in "login_id", with: @admin.login_id
    fill_in "password", with: "password"
    find("#login-submit").send_keys(:enter)
    expect(current_path).to eq admins_top_path
  end
end
