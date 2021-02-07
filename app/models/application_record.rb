class ApplicationRecord < ActiveRecord::Base
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
end
