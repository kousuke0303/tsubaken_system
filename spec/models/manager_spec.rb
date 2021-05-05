require 'rails_helper'

RSpec.describe Manager, type: :model do
  let(:manager) { Manager.first }
  
  # validates :name, presence: true, length: { maximum: 30 }
  context "name" do
    it "存在しなければ無効" do
      manager.name = ""
      expect(manager.valid?).to eq(false)
    end

    it "31文字以上は無効" do
      manager.name = (1..31).map{ "a" }.join
      expect(manager.valid?).to eq(false)
    end
  end

  # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  # validate :manager_login_id_is_correct?
  context "login_id" do
    it "存在しない場合無効" do
      manager.login_id = ""
      expect(manager.valid?).to eq(false)
    end

    it "8文字未満は無効" do
      manager.login_id = "MN-mn"
      expect(manager.valid?).to eq(false)
    end

    it "13文字以上は無効" do
      manager.login_id = "MN-" + (1..10).map{ "a" }.join
      expect(manager.valid?).to eq(false)
    end

    it "MN-から始まっていなければ無効" do
      manager.login_id = "M-managertest"
      expect(manager.valid?).to eq(false)
    end
  end

  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  context "phone" do
    it "10桁未満は無効" do
      manager.phone = "090111111"
      expect(manager.valid?).to eq(false)
    end

    it "12桁の異常は無効" do
      manager.phone = "090111122223"
      expect(manager.valid?).to eq(false)
    end

    it "0から始まっていなければは無効" do
      manager.phone = "1111111111"
      expect(manager.valid?).to eq(false)
    end

    it "数字以外の値は無効" do
      manager.phone = "aaaaaaaaaa"
      expect(manager.valid?).to eq(false)
    end
  end

  # validates :email, length: { maximum: 254 }, allow_blank: true
  context "email" do
    it "255文字以上は無効" do
      manager.email = (1..245).map{ "a" }.join + "@email.com"
      expect(manager.valid?).to eq(false)
    end

    it "emailに「@」が含まれない場合無効" do
      manager.email = "test_formattest.com"
      expect(manager.valid?).to eq(false)
    end
  end

  context "department_id" do
    it "blankは無効" do
      manager.department_id = nil
      expect(manager.valid?).to eq(false)
    end
  end
end
