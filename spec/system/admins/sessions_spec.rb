require 'rails_helper'

RSpec.describe "管理者ログイン機能", type: :system do
  let(:admin) { Admin.first }
  before do
    Capybara.page.current_window.resize_to(1200, 600)
  end

  context "ログイン" do
    before do
      visit_login_modal
    end

    context "ログインID・パスワードが適性" do
      it "ログインが出来る" do
        fill_in "login_id", with: admin.login_id
        fill_in "password", with: "password"
        find("#login-submit").send_keys(:enter)
        expect(current_path).to eq admins_top_path
      end
    end

    context "ログインIDが不正" do
      it "ログインが出来ない" do
        fill_in "login_id", with: "AD-miss"
        fill_in "password", with: "password"
        find("#login-submit").send_keys(:enter)
        expect(page).to have_content("ログインに失敗しました")
      end
    end

    context "パスワードが不正" do
      it "ログインが出来ない" do
        fill_in "login_id", with: admin.login_id
        fill_in "password", with: "passmiss"
        find("#login-submit").send_keys(:enter)
        expect(page).to have_content("ログインに失敗しました")
      end
    end
  end

  context "ログアウト" do
    it "ログアウトが出来る" do
      sign_in admin
      find("a.session-name").click
      click_link("ログアウト")
      expect(page).to have_content("ログアウトしました")
    end
  end
end
