require 'rails_helper'

RSpec.describe Manager, type: :model do
  before do
    @department = Department.create(name: "無所属")
  end
  # 次のバリデーションの確認
  # validates :name, presence: true, length: { maximum: 30 }
  # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # validate :manager_login_id_is_correct?
  # validate :joined_with_resigned
  # validate :resigned_is_since_joined
  it "nameとlogin_idが存在すれば有効、phoneとemailは存在しなくても有効、nameが30文字以内の場合有効、login_idが8から12文字以内の場合有効、login_idがMN-から始まっていれば有効" do 
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :name, presence: true
  it "nameが存在しなければ無効" do 
    @manager = @department.managers.build(
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :name, length: { maximum: 30 }
  it "nameが30文字より多い場合無効" do 
    @manager = @department.managers.build(
      name: "confirmation_of_manager_name_length",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, presence: true
  it "login_idが存在しなければ無効" do 
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, length: { in: 8..12 }
  it "login_idが8文字より少なく、12文字より多い場合無効" do 
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9-test",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, uniqueness: true
  it "login_idが一意でない場合無効" do
    @department.managers.create(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが11桁の場合有効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      phone: "08033334444",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが12桁の場合無効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      phone: "080333344445",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailが254文字以内の場合有効、emailに「@」が含まれる場合有効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      email: "test_length@test.com",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, allow_blank: true
  it "emailが254文字より多い場合無効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      email: "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailに「@」が含まれない場合無効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      email: "test_formattest.com",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :manager_login_id_is_correct?
  it "login_idがMN-から始まっていなければ無効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "M-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :joined_with_resigned
  it "退社日は入社日があれば有効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      joined_on: "2014-04-01",
      resigned_on: "2015-04-01",
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validate :joined_with_resigned
  it "退社日は入社日がないと無効" do
    @manager = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      resigned_on: "2015-04-01",
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager.valid?).to eq(false)
  end
end
