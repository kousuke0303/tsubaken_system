require 'rails_helper'

RSpec.describe Client, type: :model do
  before do
    @client = create(:client)
  end

  describe "name、kana、login_id、phone_1、phone_2、fax、emailのバリデーション確認" do
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以内の時、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :name, presence: true, length: { maximum: 30 }
    it "nameが存在し、なおかつ30文字以上の時、無効" do
      @client.name = "スタッフテスト、スタッフテスト、スタッフテスト、スタッフテスト"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :kana, presence: true, length: { maximum: 30 }
    it "kanaが存在し、なおかつ30文字以内の時、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :kana, presence: true, length: { maximum: 30 }
    it "kanaが存在し、なおかつ30文字以上の時、無効" do
      @client.kana= "こきゃくてすと、こきゃくてすと、こきゃくてすと、こきゃくてすと"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在しない時、無効" do
      @client.login_id = ""
      expect(@client.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在し、なおかつ8文字未満の時、無効" do
      @client.login_id = "CL-s-1"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    it "login_idが存在し、なおかつ12文字より多い時、無効" do
      @client.login_id = "CL-client-1222"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
    it "login_idが一意でない時、無効" do
      FactoryBot.create(:client, login_id: "CL-client-9")
      @client.login_id = "CL-client-9"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :login_id, presence: true, length: { in: 8..12 }
    # validate :client_login_id_is_correct?
    it "login_idが存在しているが、CLから始まっていない時、無効" do
      @client.login_id = "L-client-9"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phone_1が11桁の場合、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phone_1が12桁の場合、無効" do
      @client.phone_1 = "080111122223"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phone_2が11桁の場合、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
    it "phone_2が12桁の場合、無効" do
      @client.phone_2 = "080333344445"
      expect(@client.valid?).to eq(false)
    end
    
     # validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
    it "faxが11桁の場合、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
    it "faxが12桁の場合、無効" do
      @client.fax = "080333344445"
      expect(@client.valid?).to eq(false)
    end

    # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailが254文字以内の場合、有効、emailに「@」が含まれる場合、有効" do
      expect(@client.valid?).to eq(true)
    end

    # validates :email, length: { maximum: 254 }, allow_blank: true
    it "emailが254文字より多い場合、無効" do
      @client.email = "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com"
      expect(@client.valid?).to eq(false)
    end

    # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
    it "emailに「@」が含まれない場合、無効" do
      @client.email = "test_formattest.com"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
    it "郵便番号が存在し、なおかつハイフンなしの7桁で設定されていたら、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
    it "郵便番号が存在しなければ、無効" do
      @client.postal_code = ""
      expect(@client.valid?).to eq(false)
    end
    
    # validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
    it "郵便番号が7桁でなければ、無効" do
       @client.postal_code = "11122"
      expect(@client.valid?).to eq(false)
    end
    
    # validates :prefecture_code, presence: true
    it "都道府県が存在していたら、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :prefecture_code, presence: true
    it "都道府県が存在していなかったら、無効" do
      @client.prefecture_code = ""
      expect(@client.valid?).to eq(false)
    end
    
    # validates :address_city, presence: true
    it "市区町村が存在していたら、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :address_city, presence: true
    it "市区町村が存在していなかったら、無効" do
      @client.address_city = ""
      expect(@client.valid?).to eq(false)
    end
    
    # validates :address_street, presence: true
    it "町名番地が存在していたら、有効" do
      expect(@client.valid?).to eq(true)
    end
    
    # validates :address_street, presence: true
    it "町名番地が存在していなかったら、無効" do
      @client.address_street = ""
      expect(@client.valid?).to eq(false)
    end
  end
end
