import modernizr from 'modernizr';
import clipboard from 'clipboard';

var $ = require("jquery");
global.jQuery = $;


new clipboard('.btn');

$(document).ready(function() {
  // CANVAS ASIDE LEFT
  $(".js-nav-toggler--left").click(function(e) {
    e.preventDefault;
    $(".canvas").addClass("is-shifted shift-left");
  });
  // CANVAS ASIDE RIGHT
  $(".js-nav-toggler--right").click(function(e) {
    e.preventDefault;
    $(".canvas").addClass("is-shifted shift-right");
  });
  $(".js-nav-close").click(function(e) {
    e.preventDefault;
    $(".canvas").removeClass("is-shifted shift-left shift-right");
  });

});
