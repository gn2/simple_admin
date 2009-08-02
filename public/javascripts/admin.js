$(document).ready(function() {
  // // extend the default setting to always include the zebra widget. 
  // $.tablesorter.defaults.widgets = ['zebra']; 
  // // extend the default setting to always sort on the first column 
  // $.tablesorter.defaults.sortList = [[0,0]];
  // $("#users_table").tablesorter();
    
  $(".markItUp").markItUp(mySettings);
  $('a[rel*=facebox]').facebox();
});