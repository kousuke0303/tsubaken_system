schedules_arrey = ["出張", "会食", "面接", "ミーティング", "休憩", "TEST", "TEST2"]
place_arrey = ["厚木", "相模原", "市原", "平塚", "小田原", "藤沢", "茅ヶ崎"]

schedules_arrey.each do |schedule|
  place_arrey.each do |place|
    setting_time = Date.current - rand(1..7).hour
    Schedule.create(title: schedule,
                    scheduled_date: Date.current - rand(1..24).day,
                    scheduled_start_time: setting_time,
                    scheduled_end_time: setting_time + 1.hour,
                    place: place,
                    member_code_id: rand(1..10)
                    )
    Schedule.create(title: schedule,
                    scheduled_date: Date.current + 21.day - rand(1..15).day,
                    scheduled_start_time: setting_time,
                    scheduled_end_time: setting_time + 1.hour,
                    place: place,
                    member_code_id: rand(1..10)
                    )
    
  end
end


puts "CREATE! SCHEDULE"
                        
  