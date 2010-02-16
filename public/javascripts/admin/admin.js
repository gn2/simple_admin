$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

$(document).ready(function() {
  $(".markItUp").markItUp(mySettings);
  $('a[rel*=facebox]').facebox();

  // Sorting page children in sidebar
  $('ul#sortable_children').sortable({items:'li', containment:'parent', axis:'y', opacity: 0.7, update: function(e,ui) {
    $.post('/admin/pages/sort', '_method=put&'+$(this).sortable('serialize'), function(data, textStatus) {
      ui.item.find('a').highlight();
    });
  }});

  // Page tree
  $('#jstree').tree({
    ui : {
      theme_name : "apple"
    },
    callback : {
      onmove : function(node, ref_node, type, tree_obj, rb) {
        var page_id = tree_obj.get_node(node).attr("id");
        var parent_page = tree_obj.get_node(node).parent();
        var parent_page_id = parent_page.parent().attr("id");

        var serialised_page_list = ""
        parent_page.children('li').each(function(){
          serialised_page_list += 'page[]=' + $(this).attr('id').substring(5) + '&';
        });

        // Set new parent
        $.post('/admin/pages/'+page_id.substring(5)+'/update_parent', '_method=put&parent_id='+parent_page_id.substring(5));
        // Set new order for children
        $.post('/admin/pages/sort', '_method=put&'+serialised_page_list);
      }
    }
  });
  if ($.tree.focused()) {
    $.tree.focused().open_all();
  }
  $('#jstree span.page_tree_info a').click(function(){ return true; });

  $('a.page_title').hover(function(){
    $('span.page_tree_info').fadeOut('fast');
    $(this).siblings('span.page_tree_info').fadeIn('fast');
  });
  $('span.page_tree_info a').click(function(){
    window.location = $(this).attr('href');
  });

  // Sorting assets
  $("table.sortable").tableDnD({
    onDrop: function(table, row) {
      // Restyling table
      $('tr:odd',table).removeClass('even');
      $('tr:odd',table).addClass('odd');
      $('tr:even',table).removeClass('odd');
      $('tr:even',table).addClass('even');

      var assets_list = "";
      $('tbody tr', table).each(function(){
        assets_list += 'asset[]=' + $(this).attr('id').substring(6) + '&';
      });
      $.post('/admin/pages/'+page_id+'/assets/sort', '_method=put&'+assets_list);
    },
  });

});
