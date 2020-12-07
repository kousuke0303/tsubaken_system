$(function() {
  const elem = document.getElementById('talk_room');
  App.talk_room = App.cable.subscriptions.create({ channel: "TalkRoomChannel", matter: elem.dataset.matter_id }, {
    connected: function() {
      alert(elem.dataset.matter_id);
    },

    disconnected: function() {
    },
   
    received: function(data) {
      const current_name = document.getElementById('current_name');
      // 受け取った送信者の名前とチャットルームの投稿者の名前が一致・不一致による非同期処理
      if (current_name.textContent != data["sender"]){
        const messages_area = document.getElementById('chat');
        messages_area.insertAdjacentHTML('beforeend', data['recieve_html']);
      } else {
        const messages_area = document.getElementById('chat');
        messages_area.insertAdjacentHTML('beforeend', data['sender_html']);
      };
      // const add_current_name = document.getElementById('add_current_name');
      // add_current_name.textContent = current_name.textContent;
      var obj = document.getElementById("chat");
      obj.scrollTop = obj.scrollHeight;
      // var recieve_massage = message["message"] 
    },
  
    speak: function(formData) {
    // return this.perform('speak', formData);
    // if(formData.get("admin_id") != null) {
    //   return this.perform('speak', { 
    //     message: formData.get("message"),
    //     admin_id: formData.get("admin_id"),
    //     photo_name: formData.get("photo").name
    //   });
    // }else if (formData.get("manager_id") != null) {
    //   return this.perform('speak', {formData});
    // }else if (formData.get("staff_id") != null) {
    //   return this.perform('speak', {formData});
    // }else if (formData.get("external_staff_id") != null) {
    //   return this.perform('speak', {formData});
    // }
    },
  }); 
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

