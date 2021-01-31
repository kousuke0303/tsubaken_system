schedules_arrey = ["出張", "会食", "面接", "ミーティング", "休憩"]
place_arrey = ["厚木", "相模原", "市原", "平塚"]

schedules_arrey.each do |schedule|
  place_arrey.each do |place|
    setting_time = Date.current - rand(1..7).hour
    Schedule.create(title: schedule,
                     scheduled_date: Date.current + 5.day - rand(1..24).day,
                     scheduled_start_time: setting_time,
                     scheduled_end_time: setting_time + 1.hour,
                     place: place,
                     admin_id: Admin.first.id
                     )
  end
end

schedules_arrey.each do |schedule|
  place_arrey.each do |place|
    Staff.all.each do |staff|
      setting_time = Date.current - rand(1..23).hour
      Schedule.create(title: schedule,
                       scheduled_date: Date.current + 5.day - rand(1..24).day,
                       scheduled_start_time: setting_time,
                       scheduled_end_time: setting_time + 1.hour,
                       place: place,
                       staff_id: staff.id
                       )
    end
  end
end

schedules_arrey.each do |schedule|
  place_arrey.each do |place|
    Manager.all.each do |manager|
      setting_time = Date.current - rand(1..23).hour
      Schedule.create(title: schedule,
                       scheduled_date: Date.current + 5.day - rand(1..24).day,
                       scheduled_start_time: setting_time,
                       scheduled_end_time: setting_time + 1.hour,
                       place: place,
                       manager_id: manager.id
                       )
    end
  end
end
                        
  