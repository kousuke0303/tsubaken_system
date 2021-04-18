$(function() {
  var el = document.getElementById("sortable-certificates");
  if (el != null) {
    var sortable = Sortable.create(el, {
      animation: 150,
      delay: 100,
      onUpdate: function(evt) {
        $.ajax({
          type: "PATCH",
          url: "/employees/estimate_matters/:estimate_matter_id/certificates/sort",
          cache: false,
          data: { from: evt.oldIndex, 
                  to: evt.newIndex, 
                  remote: true }
        });
      }
    });
  }
});
