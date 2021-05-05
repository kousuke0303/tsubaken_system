require 'rails_helper'

RSpec.describe "Managerログイン機能", type: :system do
  let(:manager) { Manager.first }
  before do
    Capybara.page.current_window.resize_to(1200, 600)
  end

  context "ログイン" do
    before do
      visit_login_modal
    end

    context "ログインが有効" do
      context "ログインID・パスワードが適性" do
        it "ログインが出来る" do
          fill_in "login_id", with: manager.login_id
          fill_in "password", with: "password"
          find("#login-submit").send_keys(:enter)
          expect(current_path).to eq managers_top_path
        end
      end

      context "ログインIDが不正" do
        it "ログインが出来ない" do
          fill_in "login_id", with: "MN-miss"
          fill_in "password", with: "password"
          find("#login-submit").send_keys(:enter)
          expect(page).to have_content("ログインに失敗しました")
        end
      end

      context "パスワードが不正" do
        it "ログインが出来ない" do
          fill_in "login_id", with: manager.login_id
          fill_in "password", with: "passmiss"
          find("#login-submit").send_keys(:enter)
          expect(page).to have_content("ログインに失敗しました")
        end
      end
    end

    context "ログインが無効" do
      it "ログインが出来ない" do
      end
    end
  end

  context "ログアウト" do
    it "ログアウトが出来る" do
      sign_in manager
      find("a.session-name").click
      click_link("ログアウト")
      expect(page).to have_content("ログアウトしました")
    end
  end
end
