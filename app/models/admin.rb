class Admin < ApplicationRecord
  
  # テーブル数を一つにする
  validates_with AdminsValidator, on: :create
  
  # 編集・削除禁止
  before_destroy :destroy_control
  before_update :update_control
  
  # 管理者の削除を制限
  def destroy_control
    if Admin.count.to_i == 1
      errors.add(:base, "Adminは削除できません")
      throw(:abort)
    end
  end
  
  # 管理者の編集を制限
  def update_control
    if Admin.count.to_i == 1
      errors.add(:base, "Adminは編集できません")
      throw(:abort)
    end
  end
    
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
