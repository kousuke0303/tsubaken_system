require 'rails_helper'

RSpec.describe Manager, type: :model do
  before do
    @department = Department.create(name: "無所属")
    @manager = create(:manager, department: @department)
  end
  
  # 次のバリデーションの確認
  # validates :name, presence: true, length: { maximum: 30 }
  # validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # validate :manager_login_id_is_correct?
  it "nameとlogin_idが存在すれば有効、phoneとemailは存在しなくても有効、nameが30文字以内の場合有効、login_idが8から12文字以内の場合有効、login_idがMN-から始まっていれば有効" do 
    @manager.phone = ""
    @manager.email = ""
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :name, presence: true
  it "nameが存在しなければ無効" do 
    @manager.name = ""
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :name, length: { maximum: 30 }
  it "nameが30文字より多い場合無効" do 
    @manager.name = "confirmation_of_manager_name_length"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, presence: true
  it "login_idが存在しなければ無効" do
    @manager.login_id = ""
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, length: { in: 8..12 }
  it "login_idが8文字より少なく、12文字より多い場合無効" do
    @manager.login_id = "MN-manager-9-test"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :login_id, uniqueness: true
  it "login_idが一意でない場合無効" do
    @manager2 = @department.managers.build(
      name: "マネージャーテスト",
      login_id: "MN-manager-9",
      department_id: 1,
      password: "password",
      password_confirmation: "password"
    )
    expect(@manager2.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが11桁の場合有効" do
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  it "phoneが12桁の場合無効" do
    @manager.phone = "080333344445"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailが254文字以内の場合有効、emailに「@」が含まれる場合有効" do
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validates :email, length: { maximum: 254 }, allow_blank: true
  it "emailが254文字より多い場合無効" do
    @manager.email = "test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length_test_length@email.com"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  it "emailに「@」が含まれない場合無効" do
    @manager.email = "test_formattest.com"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :manager_login_id_is_correct?
  it "login_idがMN-から始まっていなければ無効" do
    @manager.login_id = "M-manager-9"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :joined_with_resigned
  # validate :resigned_is_since_joined
  it "退社日は入社日があれば有効、退社日は入社日より前であれば有効" do
    @manager.joined_on = "2014-04-01"
    @manager.resigned_on = "2015-04-01"
    expect(@manager.valid?).to eq(true)
  end

  # 次のバリデーションの確認
  # validate :joined_with_resigned
  it "退社日は入社日がないと無効" do
    @manager.resigned_on = "2015-04-01"
    expect(@manager.valid?).to eq(false)
  end

  # 次のバリデーションの確認
  # validate :resigned_is_since_joined
  it "退社日は入社日以降でないと無効" do
    @manager.joined_on = "2016-04-01"
    @manager.resigned_on = "2015-04-01"
    expect(@manager.valid?).to eq(false)
  end
end
