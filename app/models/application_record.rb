class ApplicationRecord < ActiveRecord::Base
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
      self.tasks.update_all(staff_id: nil)
      self.sales_statuses.update_all(staff_id: nil)
      designed_sales_status_editors = SalesStatusEditor.all.where(authority: "staff", id: self.id)
      designed_sales_status_editors.update_all(authority: nil, member_id: nil)
    end
    self.destroy
  rescue => e
    Rails.logger.error e.class
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    # bugsnag導入後
    # Bugsnag.notifiy e
  end
end
