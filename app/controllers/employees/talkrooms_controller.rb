class Employees::TalkroomsController < ApplicationController
  def index
    @matter = Matter.find(params[:matter_id])
    matter_messages = Message.where(matter_id: @matter.id).last(11)
    @messages_by_date = matter_messages.group_by{|list| list.created_at.to_date} 
  end
  
  def scroll_get_messages
    @matter = Matter.find(params[:matter_id])
    front_id = params[:front_id].to_i
    next_front_id = front_id - 6
    matter_first_message_id = Message.where(matter_id: @matter.id).first.id.to_i
    if next_front_id >= matter_first_message_id
      matter_messages = Message.where(matter_id: @matter.id).limit(6).offset(next_front_id - 1)
      @messages_by_date = matter_messages.group_by{|list| list.created_at.to_date} 
      @search = "true"
      respond_to do |format|
        format.js
      end
    elsif front_id == matter_first_message_id
      @search = "false"
      respond_to do |format|
        format.js
      end
    elsif matter_first_message_id > next_front_id
      matter_messages = Message.where(matter_id: @matter.id).limit(matter_first_message_id - next_front_id)
      @messages_by_date = matter_messages.group_by{|list| list.created_at.to_date} 
      @search = "true"
      respond_to do |format|
        format.js
      end
    end
  end
end
