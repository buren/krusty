// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.validate
// require turbolinks
//= require bootstrap
//= require validate
//= require courses
//= require typeahead
//= require bootstrap-datepicker
//= require_self

// Custom JavaScript for the Side Menu and Smooth Scrolling
$(document).ready(function() {

  $('.datepicker').datepicker({
    format: 'yyyy-mm-dd'
  });

  $('.focus-contact-name').on('click', function(e){
    e.preventDefault();
    $('html, body').scrollTop($("#contact-us-main-title").offset().top - 60);
    $('#signup_name').focus();
  });


  $('#course-search').typeahead([{
    name: 'courses',
    local: getCourses()
  }]);

  $(function() {
    $('a[href*=#]:not([href=#])').click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
        || location.hostname == this.hostname) {

        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top
          }, 1000);
          return false;
        }
      }
    });
  });

  $(document).on('typeahead:selected', function(o, clickedResult, dataType){
    $('#selected-courses').append(
      '<p>' +
      clickedResult.value
      + '</p>');
  });

});
