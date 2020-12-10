require 'rails_helper'

RSpec.describe Staff, type: :model do
  before do
    @department = create(:department)
    @staff = create(:staff, department: @department)
  end

  describe "name、login_id、phone、emailのバリデーション確認" do
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以内の時、有効" do
      expect(@staff.valid?).to eq(true)
    end
    
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以上の時、無効" do
      @staff.name = "スタッフテスト、スタッフテスト、スタッフテスト、スタッフテスト"
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在しない時、無効" do
      @staff.login_id = ""
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在し、なおかつ8文字未満の時、無効" do
      @staff.login_id = "ST-s-1"
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在し、なおかつ12文字より多い時、無効" do
      @staff.login_id = "ST-staff-1222"
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが一意でない時、無効" do
      FactoryBot.create(:staff, login_id: "ST-staff-9", department: @department)
      @staff.login_id = "ST-staff-9"
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    # validate :staff_login_id_is_correct?
    it "login_idが存在しているが、STから始まっていない時、無効" do
      @staff.login_id = "T-staff-9"
      expect(@staff.valid?).to eq(false)
    end
    
    # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phoneが11桁の場合、有効" do
      expect(@staff.valid?).to eq(true)
    end
    
    # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phoneが12桁の場合、無効" do
      @staff.phone = "080111122223"
      expect(@staff.valid?).to eq(false)
    end

    # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailが254文字以内の場合、有効、emailに「@」が含まれる場合、有効" do
      expect(@staff.valid?).to eq(true)
    end

    # validates :email, length: { maximum: 254 }, allow_blank: true
    it "emailが254文字より多い場合、無効" do
      @staff.email = "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com"
      expect(@staff.valid?).to eq(false)
    end

    # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailに「@」が含まれない場合、無効" do
      @staff.email = "test_formattest.com"
      expect(@staff.valid?).to eq(false)
    end
  end
end
