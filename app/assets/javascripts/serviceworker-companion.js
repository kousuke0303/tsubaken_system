if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/firebase-messaging-sw.js', { scope: './' })
    .then(function(reg) {
      console.log('firebase-messaging-sw.js registration successful with scope: ', reg.scope);
    }, function (err) {
      console.log('firebase-messaging-sw.js registration failed: ', err);
    });
}
