# frozen_string_literal: true

module ClientDecorator
  
  def avaliable_disp
    if self.avaliable
      content_tag(:span, "ログイン可能", class: "badge badge-primary")
    else
      content_tag(:span, "ログイン未許可", class: "badge badge-dark")
    end
  end
  
  def avaliable_for_show_disp
    if self.avaliable
      content_tag(:h4, "") do 
        concat content_tag(:span, "ログイン承認中", class: "badge badge-success")
      end
    else
      content_tag(:h4, "") do 
        concat content_tag(:span, "ログイン未承認中", class: "badge badge-danger")
      end
    end
  end
  
end
