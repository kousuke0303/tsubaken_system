$(document).ready(function () {
  $("#tableCollapse").on("click", function () {
    $(".responsive_table_sidebar").toggleClass("active");
    $(this).toggleClass("active");
  });
});