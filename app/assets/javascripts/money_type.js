$(".money_type").each(function(i, element){
  var text = $(element).text();
  var moneyType = String(text).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, "$1," );
  $(element).text(moneyType);
});
