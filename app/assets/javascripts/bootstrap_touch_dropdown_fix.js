/*
  See:
  https://github.com/twitter/bootstrap/issues/4796
  https://github.com/twitter/bootstrap/issues/2975#issuecomment-8670606
*/
$(function(){
  $('body').on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); });
})
