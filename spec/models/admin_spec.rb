require 'rails_helper'

RSpec.describe Admin, type: :model do
  # 次のバリデーションの確認
  # validates :name, presence: true, length: { maximum: 30 }
  # validates :phone, allow_blank: true
  # validates :email, allow_blank: true
  # validates :login_id, presence: true
  it "nameとlogin_idが存在すれば有効、phoneとemailは存在しなくても有効、nameが30文字以内の場合有効、login_idが8から12文字以内の場合有効、login_idがAD-から始まっていれば有効" do 
    @admin = Admin.new(
      name: "AD-admin-T",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin).to be_valid
  end

  # 次のバリデーションの確認
  # validates :name, presence: true
  it "nameが存在しなければ無効" do
    @admin = Admin.new(
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :name, length: { maximum: 30 }
  it "nameが30文字より多い場合無効" do
    @admin = Admin.new(
      name: "confirmation_of_admin_name_leng",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが11桁の場合有効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      phone: "09011112222",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが12桁の場合無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      phone: "090111122223",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailが254文字以内の場合有効、emailに「@」が含まれる場合有効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      email: "test_length@test.com",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, allow_blank: true
  it "emailが254文字より多い場合無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      email: "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailに「@」が含まれない場合無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      email: "test_formattest.com",
      login_id: "AD-admin",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, presence: true
  it "login_idが存在しない場合無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, length: { in: 8..12 }
  it "login_idが8文字より少なく、12文字より多い場合無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      login_id: "AD-ad",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :admin_login_id_is_correct?
  it "login_idがAD-から始まっていなければ無効" do
    @admin = Admin.new(
      name: "AD-admin-T",
      login_id: "A-admintest",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :admin_is_only
  it "管理者アカウントが既に存在した場合無効" do
    @admin = Admin.create(
      name: "AD-admin-T",
      login_id: "AD-admiest",
      password: "password",
      password_confirmation: "password"
    )
    expect(@admin.valid?).to eq(false)
  end
end
