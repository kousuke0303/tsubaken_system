class TalkRoomBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # @messages = Message.where(matter_id: message.matter_id).last(6)
    # @messages = messages.group_by{|list| list.created_at.to_date} 
    #html = render partial: "employees/talkrooms/message", locals: {message: message},formats: [:html]
    # ActionCable.server.broadcast "talk_room_channel", html: html
    
    renderer = ::ApplicationController.renderer.new
    renderer_env = renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env["warden"] = warden
    
    # 送信者・受信者のレイアウトを分けるため、送信者の名前を送信
    if message.admin_id
      @sender =  Admin.find(message.admin_id).name
    elsif message.manager_id
      @sender = Manager.find(message.manager_id).name
    elsif message.staff_id
      @sender = Staff.find(message.staff_id).name
    elsif message.external_staff_id
      @sender = ExternalStaff.find(message.external_staff_id).name
    end
    recieve_html = renderer.render(partial: "employees/talkrooms/add_recieve_message", locals: {message: message, sender: @sender})
    sender_html = renderer.render(partial: "employees/talkrooms/add_own_message", locals: {message: message, sender: @sender})
    ActionCable.server.broadcast "talk_room_channel", recieve_html: recieve_html, sender_html: sender_html, sender: @sender
    # ActionCable.server.broadcast 'talk_room_channel', message: render_message(current_admin)
    
  end
  
end
