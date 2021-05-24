function setLocalStorage(memberCode, myCount, totalCount){
  if(typeof localStorage !== 'undefined'){
    var savedMemberCode = localStorage.getItem('memberCode');
    var savedMyNotificationCount = localStorage.getItem('myNotificationCount');
    var savedTotalNotificationCount = localStorage.getItem('totalNotificationCount');

    if(savedMemberCode != null && savedMemberCode == memberCode){
      console.log('registed_for_memberCode');
    } else {
      localStorage.setItem('memberCode', memberCode);
      console.log('set_memberCode');
    };

    if(savedMyNotificationCount != null && savedMyNotificationCount == myCount){
      console.log('registed_mynotifiCount');
      catchBadge();
    } else {
      localStorage.setItem('myNotificationCount', myCount);
      catchBadge();
    };

    if(savedTotalNotificationCount != null &&
    savedTotalNotificationCount == totalCount){
      console.log('registed_totalnotifiCount');
      catchBadge();
    } else {
      localStorage.setItem('totalNotificationCount', totalCount);
      catchBadge();
      App.badge.speak(totalCount);
    };

  }
};

