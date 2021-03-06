// 勤怠編集モーダル
$(".to-edit-attendance").on("click", function() {
  let form = $("#edit-attendance-form");
  let attendanceId = $(this).data("id");
  let name = $(this).find(".name").html();
  let worledOn = $(this).data("worled-on");
  let startedAt = $(this).data("started-at");
  let finishedAt = $(this).data("finished-at");

  $("#edit-attendance-started-at").val(startedAt);
  $("#edit-attendance-name").html(name);
  $("#edit-attendance-worked-on").html(worledOn);
  if(finishedAt != "not-entered") {
    $("#edit-attendance-finished-at").val(finishedAt);
  }
  $("#edit-attendance-form").attr("action", "/employees/attendances/" + attendanceId);
  $("#to-destroy-attendance").attr("href", "/employees/attendances/" + attendanceId + "?prev_action=daily");
});
