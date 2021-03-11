$(document).ready(function () {
  $("#sidebarCollapse").on("click", function () {
    $("#sidebar").toggleClass("active");
    $(this).toggleClass("active");
  });
});

$(document).ready(function () {
  var header_user_width = $('#navbarDropdown').width() + 16;
  var dropdown_menu_width = $('.header-dropdown-menu').width();
  var difference_for_width = header_user_width - dropdown_menu_width
  $(".header-dropdown-menu").css("left", String(difference_for_width) + "px");
});
