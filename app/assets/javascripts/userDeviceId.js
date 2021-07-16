var firebaseConfig = {
    apiKey: "AIzaSyAhVjjuRBAnlQUppvd5tkcmpGCyig5M8mo",
    authDomain: "emperor-paint-18f69.firebaseapp.com",
    projectId: "emperor-paint-18f69",
    storageBucket: "emperor-paint-18f69.appspot.com",
    messagingSenderId: "819397810288",
    appId: "1:819397810288:web:38e7e0fd1256cbbecbbcb5",
    measurementId: "G-3D5Z4MM02E"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
const messaging = firebase.messaging();

var vapidKey = "BFfTZAiDquqpKcMjya-4YxXDUnrCfLSXTh7j8h3-jg1AAmOzxxartSvGLaWM72dOBqZ4WWx_A0QXGQPI_H1oP6w"
messaging.getToken({ vapidKey: vapidKey }).then((currentToken) => {
if (currentToken) {
    // Send the token to your server and update the UI if necessary
    // ...
  var instance_id = currentToken;
  $('#instance_id').val(instance_id);
  console.log(instance_id);
  } else {
    // Show permission request UI
    console.log('No registration token available. Request permission to generate one.');
    // ...
  }
}).catch((err) => {
  console.log('An error occurred while retrieving token. ', err);
  // ...
});
