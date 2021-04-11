Task.create!(category: 0, status: 0, title: "事務所清掃", content: "事務所の清掃")
Task.create!(category: 0, status: 0, title: "備品発注", content: "〇〇の注文")

Task.create!(category: 1, status: 0, title: "見積作成", alert: true, auto_set: true)
Task.create!(category: 1, status: 0, title: "診断書作成", alert: true, auto_set: true)
Task.create!(category: 1, status: 0, title: "現場調査", alert: true, auto_set: true, content: "現場調査")
Task.create!(category: 1, status: 0, title: "架電", content: "〇〇に電話連絡")

Task.create!(category: 2, status: 0, title: "足場架設依頼", alert: true, auto_set: true)
Task.create!(category: 2, status: 0, title: "発注", alert: true, auto_set: true)
Task.create!(category: 2, status: 0, title: "現場清掃", content: "掃除")
Task.create!(category: 2, status: 0, title: "近隣挨拶", content: "隣の家に挨拶")
puts "CREATE! DEFALTE_TASK"