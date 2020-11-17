class ApplicationRecord < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A0\d{9,10}\z/i
  VALID_FAX_REGEX = /\A0\d{9}\z/i
  self.abstract_class = true
end
