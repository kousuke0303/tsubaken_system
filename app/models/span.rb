class Span
  include ActiveModel::Model
  
  attr_accessor :first_day
  attr_accessor :last_day
  attr_accessor :span
  
  def one_month
    self.first_day = Date.current.beginning_of_month
    self.last_day = first_day.end_of_month
  end
  
  def after_two_month(reference_date)
    self.first_day = reference_date.beginning_of_month
    self.last_day = first_day.next_month.end_of_month
    self.span = 2
  end
  
  def three_month(reference_date)
    self.first_day = reference_date.beginning_of_month - 2.month
    self.last_day = reference_date.end_of_month
    self.span = 3
  end
  
  def six_month(reference_date)
    self.first_day = reference_date.beginning_of_month - 5.month
    self.last_day = reference_date.end_of_month
    self.span = 6
  end
end
