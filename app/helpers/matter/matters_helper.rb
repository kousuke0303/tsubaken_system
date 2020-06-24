module Matter::MattersHelper
  
  def matter_day(day)
    day.strftime('%Y年%m月%d日')
  end
  
  def manage_authority_badge(submanager)
    if submanager.matter_submanagers.find_by(matter_id: current_matter.id).manage_authority == true
      content_tag :span, "窓口担当", class: "badge badge-pill badge-info ml-1e"
    end
  end
end
