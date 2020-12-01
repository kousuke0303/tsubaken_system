require 'rails_helper'

RSpec.describe ExternalStaff, type: :model do
  before do
    @supplier = create(:supplier)
    @external_staff = create(:external_staff, supplier: @supplier, supplier_id: @supplier.id)
  end
  
  describe "name、kana、login_id、phone、emailのバリデーション確認" do
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以内の時、有効" do
      expect(@external_staff.valid?).to eq(true)
    end
    
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以上の時、無効" do
      @external_staff.name = "外部スタッフテスト、外部スタッフテスト、外部スタッフテスト、外部スタッフテスト"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :kana, presence: true, length: { maximum: 30 }
    it "kanaが存在し、なおかつ30文字以内の時、有効" do
      expect(@external_staff.valid?).to eq(true)
    end
    
    # validates :kana, presence: true, length: { maximum: 30 }
    it "kanaが存在し、なおかつ30文字以上の時、無効" do
      @external_staff.kana= "がいぶすたっふてすと、がいぶすたっふてすと、がいぶすたっふてすと、がいぶすたっふてすと"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが存在しない時、無効" do
      @external_staff.login_id = ""
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが存在し、なおかつ8文字未満の時、無効" do
      @external_staff.login_id = "SP#{@supplier.id}-"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが存在し、なおかつ12文字より多い時、無効" do
      @external_staff.login_id = "SP#{@supplier.id}-supsup-1222"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが一意でない時、無効" do
      FactoryBot.create(:external_staff, login_id: "SP#{@supplier.id}-sup-1", supplier: @supplier)
      @external_staff.login_id = "SP#{@supplier.id}-sup-1"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    # validate :external_staff_login_id_is_correct?
    it "login_idが存在しているが、SP(外注先ID)から始まっていない時、無効" do
      @external_staff.login_id = "su#{@supplier.id}-sup-9"
      expect(@external_staff.valid?).to eq(false)
    end
    
    # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phoneが11桁の場合、有効" do
      expect(@external_staff.valid?).to eq(true)
    end
    
    # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phoneが12桁の場合、無効" do
      @external_staff.phone = "080111122223"
      expect(@external_staff.valid?).to eq(false)
    end

    # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailが254文字以内の場合、有効、emailに「@」が含まれる場合、有効" do
      expect(@external_staff.valid?).to eq(true)
    end

    # validates :email, length: { maximum: 254 }, allow_blank: true
    it "emailが254文字より多い場合、無効" do
      @external_staff.email = "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com"
      expect(@external_staff.valid?).to eq(false)
    end

    # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailに「@」が含まれない場合、無効" do
      @external_staff.email = "test_formattest.com"
      expect(@external_staff.valid?).to eq(false)
    end
  end
end
