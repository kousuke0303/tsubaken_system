class BadgesController < ApplicationController
  def count
    membercode = MemberCode.find(params[:member_code])
    @badge_count = membercode.recieve_notifications.where(status: 0).count
  end
end
