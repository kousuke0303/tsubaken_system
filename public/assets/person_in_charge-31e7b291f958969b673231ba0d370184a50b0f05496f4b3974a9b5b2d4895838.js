// 担当者設定フォームの表示切替
var staffSelect = $("#staff-select");
var externalStaffSelect = $("#external-staff-select");
var staff = $("#staff");
var externalStaff = $("#external-staff");

staffSelect.hide();
externalStaffSelect.hide();

$("#staff-btn").click(function() {
  staffSelect.show();
  externalStaffSelect.hide();
});

$("#external-staff-btn").click(function() {
  staffSelect.hide();
  externalStaffSelect.show();
});

staff.change(function() {
  if($(this).val() != "") {
    $("#external-staff").val("");
  }
});
externalStaff.change(function() {
  if($(this).val() != "") {
    $("#staff").val("");
  }
});
