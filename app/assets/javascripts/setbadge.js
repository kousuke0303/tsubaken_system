function setBadge(...args) {
  if (navigator.setAppBadge) {
    navigator.setAppBadge(...args);
  } else if (navigator.setExperimentalAppBadge) {
    navigator.setExperimentalAppBadge(...args);
  } else if (window.ExperimentalBadge) {
    window.ExperimentalBadge.set(...args);
  }
};

function catchBadge(){
  console.log('catch_badge');
  var memberCode = localStorage.getItem('memberCode');
  $.ajax({
    type: 'GET',
    url: "/badge_count",
    data: {member_code: memberCode}
  });
};