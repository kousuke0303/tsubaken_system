$(document).ready(function () {
  $("#tableCollapse").on("click", function () {
    $(".responsive_table_sidebar").toggleClass("active");
    $(this).toggleClass("active");
  });
});

$(document).ready(function () {
  $("#tableLongCollapse").on("click", function () {
    $(".responsive_table_long_sidebar").toggleClass("active");
    $(this).toggleClass("active");
  });
});