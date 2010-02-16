$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

$(document).ready(function() {
  // // extend the default setting to always include the zebra widget.
  // $.tablesorter.defaults.widgets = ['zebra'];
  // // extend the default setting to always sort on the first column
  // $.tablesorter.defaults.sortList = [[0,0]];
  // $("#users_table").tablesorter();

  $(".markItUp").markItUp(mySettings);
  $('a[rel*=facebox]').facebox();

  $('ul#sortable_children').sortable({items:'li', containment:'parent', axis:'y', opacity: 0.7, update: function(e,ui) {
    $.post('/admin/pages/sort', '_method=put&'+$(this).sortable('serialize'), function(data, textStatus) {
      ui.item.find('a').highlight();
    });
  }});
  
});