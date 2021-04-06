$(function() {
  let el = document.getElementById("sortable-categories");
  if (el != null) {
    const sortable = Sortable.create(el, {
      animation: 150,
      delay: 100,
      onUpdate: function(evt) {
        $.ajax({
          type: "PATCH",
          url: "/employees/settings/estimates/categories/sort",
          cache: false,
          data: { from: evt.oldIndex, 
                  to: evt.newIndex, 
                  remote: true }
        });
      }
    });
  }
});
