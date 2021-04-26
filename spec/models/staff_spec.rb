require 'rails_helper'

RSpec.describe Staff, type: :model do
  let(:staff) { Staff.first }
  
  # validates :name, presence: true, length: { maximum: 30 }
  context "name" do
    it "存在しなければ無効" do
      staff.name = ""
      expect(staff.valid?).to eq(false)
    end

    it "31文字以上は無効" do
      staff.name = (1..31).map{ "a" }.join
      expect(staff.valid?).to eq(false)
    end
  end

  # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  # validate :staff_login_id_is_correct?
  context "login_id" do
    it "存在しない場合無効" do
      staff.login_id = ""
      expect(staff.valid?).to eq(false)
    end

    it "8文字未満は無効" do
      staff.login_id = "ST-st"
      expect(staff.valid?).to eq(false)
    end

    it "13文字以上は無効" do
      staff.login_id = "ST-" + (1..10).map{ "a" }.join
      expect(staff.valid?).to eq(false)
    end

    it "ST-から始まっていなければ無効" do
      staff.login_id = "M-stafftest"
      expect(staff.valid?).to eq(false)
    end
  end

  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  context "phone" do
    it "10桁未満は無効" do
      staff.phone = "090111111"
      expect(staff.valid?).to eq(false)
    end

    it "12桁の異常は無効" do
      staff.phone = "090111122223"
      expect(staff.valid?).to eq(false)
    end

    it "0から始まっていなければは無効" do
      staff.phone = "1111111111"
      expect(staff.valid?).to eq(false)
    end

    it "数字以外の値は無効" do
      staff.phone = "aaaaaaaaaa"
      expect(staff.valid?).to eq(false)
    end
  end

  # validates :email, length: { maximum: 254 }, allow_blank: true
  context "email" do
    it "255文字以上は無効" do
      staff.email = (1..245).map{ "a" }.join + "@email.com"
      expect(staff.valid?).to eq(false)
    end

    it "emailに「@」が含まれない場合無効" do
      staff.email = "test_formattest.com"
      expect(staff.valid?).to eq(false)
    end
  end

  context "department_id" do
    it "blankは無効" do
      staff.department_id = nil
      expect(staff.valid?).to eq(false)
    end
  end
end
