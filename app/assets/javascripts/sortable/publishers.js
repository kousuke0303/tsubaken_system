$(function() {
  let el = document.getElementById("sortable-publishers");
  if (el != null) {
    const sortable = Sortable.create(el, {
      animation: 150,
      delay: 100,
      onUpdate: function(evt) {
        $.ajax({
          type: "PATCH",
          url: "/employees/settings/companies/publishers/sort",
          cache: false,
          data: { from: evt.oldIndex, 
                  to: evt.newIndex, 
                  remote: true }
        });
      }
    });
  }
});
