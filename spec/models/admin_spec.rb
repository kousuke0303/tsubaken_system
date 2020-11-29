require 'rails_helper'

RSpec.describe Admin, type: :model do
  # 名前が存在し、なおかつ30文字以内か
  it "valid name and 30" do
    admin = Admin.create(
        name: "Joe"
    )
    expect(admin.name).to 
  end
end
