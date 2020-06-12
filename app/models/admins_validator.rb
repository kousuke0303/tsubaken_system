class AdminsValidator < ActiveModel::Validator
  
  def validate(record)
    if Admin.exists?
      record.errors[:base] << "管理者は新規作成できません"
    end
  end
      
end