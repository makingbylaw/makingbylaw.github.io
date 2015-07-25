$(function() { 
  $('.gallery-nav ul li a').click(function() {
    $('.gallery-nav ul li').removeClass('current');
    $(this).closest('li').addClass('current');

    var cat = $(this).attr('data-cat');

    var gallery = $('.gallery-nav').closest('.portfolio-gallery').find('ul.gallery');

    if (cat === 'all') {
      $('li', gallery).removeClass('hidden');
    } else {
      $('li', gallery).each(function() {
        if ($(this).hasClass(cat)) {
          $(this).removeClass('hidden');
        } else {
          $(this).addClass('hidden');
        }
      });
    }

    return false;

  });

});