module Employees::TasksHelper

  def matter_tasks(matter)
    matter.tasks.are_matter_tasks
  end
  
  def matter_progress_tasks(matter)
    matter.tasks.are_progress_tasks
  end
  
  def matter_complete_tasks(matter)
    matter.tasks.are_finished_tasks
  end
  
  def requesting_company(matter)
    matter.managers.first.company
  end

end