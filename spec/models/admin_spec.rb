require 'rails_helper'

RSpec.describe Admin, type: :model do
  before do
    @admin = Admin.first
  end

  # validates :name, presence: true, length: { maximum: 30 }
  context "name" do
    it "存在しなければ無効" do
      @admin.name = ""
      expect(@admin.valid?).to eq(false)
    end

    it "31文字以上は無効" do
      @admin.name = (1..31).map{ "a" }.join
      expect(@admin.valid?).to eq(false)
    end
  end

  # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  # validate :admin_login_id_is_correct?
  context "login_id" do
    it "存在しない場合無効" do
      @admin.login_id = ""
      expect(@admin.valid?).to eq(false)
    end

    it "8文字未満は無効" do
      @admin.login_id = "AD-ad"
      expect(@admin.valid?).to eq(false)
    end

    it "13文字以上は無効" do
      @admin.login_id = "AD-" + (1..10).map{ "a" }.join
      expect(@admin.valid?).to eq(false)
    end

    it "AD-から始まっていなければ無効" do
      @admin.login_id = "A-admintest"
      expect(@admin.valid?).to eq(false)
    end
  end

  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  context "phone" do
    it "10桁未満は無効" do
      @admin.phone = "090111111"
      expect(@admin.valid?).to eq(false)
    end

    it "12桁の異常は無効" do
      @admin.phone = "090111122223"
      expect(@admin.valid?).to eq(false)
    end

    it "0から始まっていなければは無効" do
      @admin.phone = "1111111111"
      expect(@admin.valid?).to eq(false)
    end

    it "数字以外の値は無効" do
      @admin.phone = "aaaaaaaaaa"
      expect(@admin.valid?).to eq(false)
    end
  end

  # validates :email, length: { maximum: 254 }, allow_blank: true
  context "email" do
    it "255文字以上は無効" do
      @admin.email = (1..245).map{ "a" }.join + "@email.com"
      expect(@admin.valid?).to eq(false)
    end

    it "emailに「@」が含まれない場合無効" do
      @admin.email = "test_formattest.com"
      expect(@admin.valid?).to eq(false)
    end
  end
end
