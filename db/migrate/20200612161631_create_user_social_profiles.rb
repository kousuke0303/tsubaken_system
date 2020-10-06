class CreateUserSocialProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_social_profiles do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :url
      t.string :image_url
      t.string :description
      t.text :other
      t.text :credentials
      t.text :raw_info

      t.timestamps
    end
  end
end
