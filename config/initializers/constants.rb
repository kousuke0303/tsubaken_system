module Constants
  UPPERCASE_LATTER = ("A".."Z").to_a
  EMPLOYEES_TYPE_HASH = { "Manager": 1, "Staff": 2, "外部Staff": 3 }
  MONTH_HASH = { "1月": "01", "2月": "02", "3月": "03", "4月": "04", "5月": "05", "6月": "06",
                 "7月": "07", "8月": "08", "9月": "09", "10月": "10", "11月": "11", "12月": "12" }
  DAYS_OF_THE_WEEK = %w{ 日 月 火 水 木 金 土 }
end