module Sessions
  def sign_in(resource)
    visit root_url
    find(".to-login-btn").click
    fill_in "login_id", with: resource.login_id
    fill_in "password", with: "password"
    find("#login-submit").send_keys(:enter)
  end
end
