// App.badge = App.cable.subscriptions.create "BadgeChannel",
//   connected: ->
//     # Called when the subscription is ready for use on the server
//     console.log 'badge-server待機中'
//   disconnected: ->
//     # Called when the subscription has been terminated by the server
//     console.log 'badge-server-down'
//   received: (data) ->
//     # Called when there's incoming data on the websocket for this channel
//     count = Number(data['message'])
//     # window.alert count
//     localStorage.setItem 'totalNotificationCount', count
//     $('#badge-notification').html '<%= escape_javascript(render'layouts/flamework/parts/notification') %>'
//   speak: (message) ->
//     # window.alert 'message'
//     @perform 'speak', message: message

App.badge = App.cable.subscriptions.create("BadgeChannel", {
  connected: function() {
    return console.log('badge-server待機中');
  },
  disconnected: function() {
    return console.log('badge-server-down');
  },
  received: function(data) {
    console.log(data);
    var totalCount;
    var recieverId;
    var recieverCount;
    var registorId;
    totalCount = Number(data['notificationDate'][0]);
    localStorage.setItem('totalNotificationCount', totalCount);
    recieverId = Number(data['notificationDate'][1]);
    recieverCount = Number(data['notificationDate'][2]);
    registorId = localStorage.getItem('memberCode');
    console.log(registorId);
    if(registorId == recieverId){
      //header変更
      var elems = document.getElementsByClassName('notifi-badge');
      elems[0].innerHTML = recieverCount;
      // badge変更
      if (navigator.setAppBadge) {
        navigator.setAppBadge(recieverCount);
      } else if (navigator.setExperimentalAppBadge) {
        navigator.setExperimentalAppBadge(recieverCount);
      } else if (window.ExperimentalBadge) {
        window.ExperimentalBadge.set(recieverCount);
      }
    }
  },
  
  speak: function(data) {
    return this.perform('speak', {
      notificationDate: data
    });
  }
});
