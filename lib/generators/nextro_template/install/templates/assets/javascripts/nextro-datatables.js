$(document).ready(function() {
  $(".nextro-datatable").each(function() {
    init_dttb($(this));
  });
});

function init_dttb(element) {
  if (typeof $.fn.DataTable !== "undefined" && !$.fn.DataTable.isDataTable(element)) {
    return element.DataTable();
  }
  return null;
}
