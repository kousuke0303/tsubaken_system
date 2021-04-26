module LoginPreparation
  def visit_login_modal
    visit root_url
    find(".to-login-btn").click
  end
end
