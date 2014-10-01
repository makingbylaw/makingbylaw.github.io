$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }

    var sections = {},
        _height  = $(window).height(),
        i        = 0;
    
    // Grab positions of our sections 
    $('.section').each(function(){
        sections[this.name] = $(this).offset().top;
    });

    $(document).scroll(function(){
        var $this = $(this),
            pos   = $this.scrollTop();
            
        for(i in sections){
            if(sections[i] > pos && sections[i] < pos + _height){
                $('a').removeClass('active');
                $('#nav_' + i).addClass('active');
            }  
        }
    });
});

  });

jQuery(document).ready(function($){
  var contentSections = $('.cd-section'),
    navigationItems = $('#cd-vertical-nav a');

  updateNavigation();
  $(window).on('scroll', function(){
    updateNavigation();
  });

  //smooth scroll to the section
  navigationItems.on('click', function(event){
        event.preventDefault();
        smoothScroll($(this.hash));
    });
    //smooth scroll to second section
    $('.cd-scroll-down').on('click', function(event){
        event.preventDefault();
        smoothScroll($(this.hash));
    });

    //open-close navigation on touch devices
    $('.touch .cd-nav-trigger').on('click', function(){
      $('.touch #cd-vertical-nav').toggleClass('open');
  
    });
    //close navigation on touch devices when selectin an elemnt from the list
    $('.touch #cd-vertical-nav a').on('click', function(){
      $('.touch #cd-vertical-nav').removeClass('open');
    });

  function updateNavigation() {
    contentSections.each(function(){
      $this = $(this);
      var activeSection = $('#cd-vertical-nav a[href="#'+$this.attr('id')+'"]').data('number') - 1;
      if ( ( $this.offset().top - $(window).height()/2 < $(window).scrollTop() ) && ( $this.offset().top + $this.height() - $(window).height()/2 > $(window).scrollTop() ) ) {
        navigationItems.eq(activeSection).addClass('is-selected');
      }else {
        navigationItems.eq(activeSection).removeClass('is-selected');
      }
    });
  }

  function smoothScroll(target) {
        $('body,html').animate(
          {'scrollTop':target.offset().top},
          600
        );
  }
});