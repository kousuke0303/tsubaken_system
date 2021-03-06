module Constants
  UPPERCASE_LATTER = ("A".."Z").to_a
  EMPLOYEES_AUTH_HASH = { "Manager": 1, "Staff": 2, "外部Staff": 3 }
  MONTH_HASH = { "1月": "1", "2月": "2", "3月": "3", "4月": "4", "5月": "5", "6月": "6",
                 "7月": "7", "8月": "8", "9月": "9", "10月": "10", "11月": "11", "12月": "12" }
  DAYS_OF_THE_WEEK = %w{ 日 月 火 水 木 金 土 }
end
