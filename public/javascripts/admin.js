$(document).ready(function() {
  // extend the default setting to always include the zebra widget. 
  $.tablesorter.defaults.widgets = ['zebra']; 
  // extend the default setting to always sort on the first column 
  $.tablesorter.defaults.sortList = [[0,0]];
  
  $("#users_table").tablesorter();
  
  // Jquery plugin autoresize
  $('textarea.resizable').autoResize({
      // On resize:
      onResize : function() {
          $(this).css({opacity:0.8});
      },
      // After resize:
      animateCallback : function() {
          $(this).css({opacity:1});
      },
      // Quite slow animation:
      animateDuration : 300,
      // More extra space:
      // extraSpace : 40
  }).trigger('change');
  
});