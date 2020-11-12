class Task < ApplicationRecord
  belongs_to :matter, inverse_of: :tasks, optional: true
  belongs_to :task_alias, class_name: 'Task', optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 3000 }
  
  enum status: {default: 0, relevant: 1, ongoing: 2, finished: 3}
  
  task_alias = Task.arel_table.alias('task_alias')
  
  task_alias_join = arel_table.join(task_alias, Arel::Nodes::InnerJoin)
      .on(task_alias[:default_task_id].eq arel_table[:default_task_id]).join_sources
   
  scope :are_default, -> { default.order(:sort_order) }
  scope :are_relevant, -> { relevant.order(:sort_order) }
  scope :are_ongoing, -> { ongoing.order(:sort_order) }
  scope :are_finished, -> { finished.order(:sort_order) }
  scope :are_default_task_id_count, -> { Task.joins(task_alias_join).count }
  

  # sort_orderを正しい連番に更新
  def self.reload_sort_order(tasks)
    tasks.order(:sort_order).each_with_index do |task, index|
      task.update(sort_order: index)
    end
  end

  # sort_orderを+1に更新
  def self.increment_sort_order(matter, status, sort_order)
    matter.tasks.where(status: status).where("sort_order >= ?", sort_order).each do |task|
      new_sort_order = task.sort_order.to_i + 1
      task.update(sort_order: new_sort_order)
    end
  end

  # sort_orderを-1に更新
  def self.decrement_sort_order(matter, status, sort_order)
    matter.tasks.where(status: status).where("sort_order <= ?", sort_order).each do |task|
      unless task.sort_order == 0
        new_sort_order = task.sort_order.to_i - 1
        task.update(sort_order: new_sort_order)
      end
    end
  end
  
  def self.convert_to_status_num(status)
    case status
    when "relevant-tasks"
      1
    when "ongoing-tasks"
      2
    when "finished-tasks"
      3
    end
  end

end
