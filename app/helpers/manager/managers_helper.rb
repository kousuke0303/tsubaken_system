module Manager::ManagersHelper
  
  def employee_staff
    Staff.employee_staff(dependent_manager)
  end
  
  def outsourcing_staff
    Staff.outsourcing_staff(dependent_manager)
  end
end
