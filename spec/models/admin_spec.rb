require 'rails_helper'

RSpec.describe Admin, type: :model do
  before do
    @admin = build(:admin)
  end

  # # 次のバリデーションの確認
  # # validates :name, presence: true, length: { maximum: 30 }
  # # validates :phone, allow_blank: true
  # # validates :email, allow_blank: true
  # # validates :login_id, presence: true
  # # validate :admin_login_id_is_correct?
  it "nameとlogin_idが存在すれば有効、phoneとemailは存在しなくても有効、nameが30文字以内の場合有効、login_idが8から12文字以内の場合有効、login_idがAD-から始まっていれば有効" do 
    @admin.phone = ""
    @admin.email = ""
    expect(@admin.valid?).to eq(true)
  end

  # # 次のバリデーションの確認
  # # validates :name, presence: true
  it "nameが存在しなければ無効" do
    @admin.name = ""
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :name, length: { maximum: 30 }
  it "nameが30文字より多い場合無効" do
    @admin.name = "confirmation_of_admin_name_leng"
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが11桁の場合有効" do
    expect(@admin.valid?).to eq(true)
  end

  # # 次のバリデーションの確認
  # # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが12桁の場合無効" do
    @admin.phone = "090111122223"
    expect(@admin.valid?).to eq(false)
  end

  # # 次のバリデーションの確認
  # # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailが254文字以内の場合有効、emailに「@」が含まれる場合有効" do
    expect(@admin.valid?).to eq(true)
  end

  # # 次のバリデーションの確認
  # # validates :email, length: { maximum: 254 }, allow_blank: true
  it "emailが254文字より多い場合無効" do
    @admin.email = "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com"
    expect(@admin.valid?).to eq(false)
  end

  # # 次のバリデーションの確認
  # # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailに「@」が含まれない場合無効" do
    @admin.email = "test_formattest.com"
    expect(@admin.valid?).to eq(false)
  end

  # # 次のバリデーションの確認
  # # validates :login_id, presence: true
  it "login_idが存在しない場合無効" do
    @admin.login_id = ""
    expect(@admin.valid?).to eq(false)
  end

  # # 次のバリデーションの確認
  # # validates :login_id, length: { in: 8..12 }
  it "login_idが8文字より少なく、12文字より多い場合無効" do
    @admin.login_id = "AD-ad"
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :admin_login_id_is_correct?
  it "login_idがAD-から始まっていなければ無効" do
    @admin.login_id = "A-admintest"
    expect(@admin.valid?).to eq(false)
  end
end
