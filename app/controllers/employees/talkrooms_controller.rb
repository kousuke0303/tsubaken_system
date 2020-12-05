class Employees::TalkroomsController < ApplicationController
  
  def index
    @matter = Matter.find(params[:matter_id])
    matter_messages = Message.where(matter_id: @matter.id).last(11)
    @messages_by_date = matter_messages.group_by{|list| list.created_at.to_date} 
  end
  
  def create
    @matter = Matter.find(params[:matter_id])
    if message = @matter.messages.create(message_params)
      if admin_signed_in?
        @sender =  current_admin.name
      elsif manager_signed_in?
        @sender = current_manager.name
      elsif staff_signed_in?
        @sender = staff_signed_in.name
      elsif external_staff_signed_in?
        @sender = current_external_staff.name
      end
      
      renderer = ::ApplicationController.renderer.new
      renderer_env = renderer.instance_eval { @env }
      warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
      renderer_env["warden"] = warden
      
      if message.photo.attached?
        recieve_html = renderer.render(partial: "employees/talkrooms/add_recieve_message", locals: {message: message, sender: @sender, photo: url_for(message.photo) })
        sender_html = renderer.render(partial: "employees/talkrooms/add_own_message", locals: {message: message, sender: @sender, photo: url_for(message.photo)})
      else
        photo = nil
        recieve_html = renderer.render(partial: "employees/talkrooms/add_recieve_message", locals: {message: message, sender: @sender, photo: photo })
        sender_html = renderer.render(partial: "employees/talkrooms/add_own_message", locals: {message: message, sender: @sender, photo: photo})
      end
      ActionCable.server.broadcast "talk_room_channel_#{@matter.id}", recieve_html: recieve_html, sender_html: sender_html, sender: @sender
    end
  end
  
  def scroll_get_messages
    @matter = Matter.find(params[:matter_id])
    # 1表示されているメッサージのidを変数化
    front_id = params[:front_id].to_i
    # スクロールしたら６メッサージずつプレビュー
    next_front_id = front_id - 6
    matter_first_message_id = Message.where(matter_id: @matter.id).first.id.to_i
    # 先頭のidから以前のデータが６個以上あるか否かで場合分
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
  
  private
   def message_params
     params.permit(:message, :photo, :matter_id, :admin_id, :manager_id, :staff_id, :external_staff_id)
   end
    
end
