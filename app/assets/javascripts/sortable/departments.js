$(function() {
  let el = document.getElementById("sortable-departments");
  if (el != null) {
    const sortable = Sortable.create(el, {
      animation: 150,
      delay: 100,
      onUpdate: function(evt) {
        $.ajax({
          type: "PATCH",
          url: "/employees/settings/companies/departments/sort",
          cache: false,
          data: { from: evt.oldIndex, 
                  to: evt.newIndex, 
                  remote: true }
        });
      }
    });
  }
});