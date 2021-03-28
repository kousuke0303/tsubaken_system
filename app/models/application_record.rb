class ApplicationRecord < ActiveRecord::Base
  
  with_options on: :destroy_check do
    validate :necessary_of_accept
  end
  # user削除時確認用
  attr_accessor :accept
  
  VALID_KANA_REGEX = /\A[ァ-ヶー　]*\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A0\d{9,10}\z/i
  VALID_FAX_REGEX = /\A0\d{9,10}\z/i
  VALID_POSTAL_CODE_REGEX = /\A\d{7}\z/
  VALID_COLOR_CODE_REGEX = /\A#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/
  self.abstract_class = true
  
  # 住所機能
  include JpPrefecture
  jp_prefecture :prefecture_code
  
  
  # ---------------------------------------------------------
        # 住所自動入力
  # ---------------------------------------------------------
  # 郵便番号(postal_code)から都道府県名(prefecture_name)に変換するメソッド
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  # 郵便番号(postal_code)から都道府県名(prefecture_name)に変換するメソッド
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
  #-----------------------------------------------------
    # IBSTANCE_METHOD
  #-----------------------------------------------------
  
  # 従業員等の抹消
  def relation_destroy
    ActiveRecord::Base.transaction do
      target_member_code = self.member_code.id
      Task.where(member_code_id: target_member_code).update_all(member_code_id: nil)
      Schedule.where(member_code_id: target_member_code).update_all(member_code_id: nil)
      SalesStatus.where(member_code_id: target_member_code).update_all(member_code_id: nil)
      SalesStatusEditor.where(member_code_id: target_member_code).update_all(member_code_id: nil)
    end
    self.destroy
  rescue => e
    Rails.logger.error e.class
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    # bugsnag導入後
    # Bugsnag.notifiy e
  end
  
  # destroyはtrue/falseを返さないので、falseを返すよう記述
  def necessary_of_accept
    unless self.accept == 1
      errors.add(:accept, "チェックボックスが空欄です")
      return false
    end
  end
end
