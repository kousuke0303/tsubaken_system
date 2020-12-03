module ApplicationHelper
  
  def avator(login_user)
    login_user.avator.attached? ? login_user.avator : login_user.name[0, 1]
  end  
    
  
end
