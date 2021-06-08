# frozen_string_literal: true

module ClientDecorator
  
  def avaliable_disp
    if self.avaliable
      content_tag(:span, "ログイン可能", class: "badge badge-primary")
    else
      content_tag(:span, "ログイン未許可", class: "badge badge-dark")
    end
  end
end
