$("#print").click(function() {
  $("body > :not(#print-area)").hide();
  $("body").addClass("bg-white");
  $("#print-area").show();
  window.print();
  $("body > :not(#print-area)").show();
  $("#print-area").hide();
  $("body").removeClass("bg-white");
});
