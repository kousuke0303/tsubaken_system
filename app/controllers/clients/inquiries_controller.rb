class Clients::InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      flash[:notice] = "お問合せを送信しました。返信をお待ちください。"
      redirect_to root_url
    end
  end

  private
    def inquiry_params
      params.require(:inquiry).permit(:name, :kana, :kind, :phone, :email, :reply_email)
    end
end
