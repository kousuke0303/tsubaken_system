module Employees::AttendancesHelper
  def daily_working_time(working_minutes)
    hours = (working_minutes.to_i / 60).to_s
    hours = "0" + hours if hours.length == 1
    minutes = (working_minutes.to_i % 60).to_s
    minutes = "0" + minutes if minutes.length == 1
    "#{ hours }:#{ minutes }"
  end

  def monthly_working_time(total_working_minutes)
    hours = (total_working_minutes.to_i / 60).to_s
    minutes = (total_working_minutes.to_i % 60).to_s
    "#{ hours }時間#{ minutes }分"
  end
end
