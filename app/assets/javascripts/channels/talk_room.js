App.talk_room = App.cable.subscriptions.create("TalkRoomChannel", {
  connected: function() {
  },

  disconnected: function() {
  },
   
  received: function(data) {
    const current_name = document.getElementById('current_name');
    // 受け取った送信者の名前とチャットルームの投稿者の名前が一致した場合のみ非同期処理
    if (current_name.textContent != data["sender"]){
      const messages = document.getElementById('message_container');
      messages.insertAdjacentHTML('beforeend', data['html']);
    };
    // const add_current_name = document.getElementById('add_current_name');
    // add_current_name.textContent = current_name.textContent;
    var obj = document.getElementById("chat");
    obj.scrollTop = obj.scrollHeight;
    // var recieve_massage = message["message"] 
  },
  
  speak: function(message, matter_id, admin_id, manager_id, staff_id, external_staff_id) {
    if(admin_id != null) {
      return this.perform('speak', {message: message, matter_id: matter_id, admin_id: admin_id});
    }else if (manager_id != null) {
      return this.perform('speak', {message: message, matter_id: matter_id, manager_id: manager_id});
    }else if (staff_id != null) {
      return this.perform('speak', {message: message, matter_id: matter_id, staff_id: staff_id});
    }else if (external_staff_id != null) {
      return this.perform('speak', {message: message, matter_id: matter_id, external_staff_id: external_staff_id});
    }
  },
});
  
  // $(document).on 'keypress', '[data-behavior~=speak_talk_rooms]', (event) ->
  // if event.keyCode is 13 # keyCode=13(returnキー)
  //   App.talk_room.speak event.target.value
  //   event.target.value = ""
  //   event.preventDefault()
  
// $(function(){
//   $(".chat_submit").on("click",function(){
//     var message = $("#chat-input").val();
//     var matter_id = $('#matter_id').val();
//     var admin_id = $("#admin_id").val();
//     var manager_id = $("#manager_id").val();
//     var staff_id = $("#staff_id").val();
//     var external_staff_id = $("external_staff_id").val();
    
//     App.talk_room.speak(message, matter_id, admin_id, manager_id, staff_id, external_staff_id);
//     $(".chat-input").val("");
//   });
// });

