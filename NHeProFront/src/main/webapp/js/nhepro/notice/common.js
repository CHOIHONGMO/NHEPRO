$(function () {
    $('a[href="#"]').on('click', function (e) {
        e.preventDefault();
    });
    $('#slideMain').bxSlider({
        controls : false,
        auto: true,
        speed: 500,
        moveSlides:1
    });
    $('.yongma_logo').on('click', function(e) {
        location.href = '/welcome.so';
    });
    $('.button_clear').on('click', function(e) {
        $('.input_id').val('');
    });
    //메인메뉴
    $('.menu_title').mouseover(function(){
        $('.bg_box').stop().animate({height:300},100);
    });
    $('.menu_title').mouseout(function(){
        $('.bg_box').stop().animate({height: 0},100);
    });
    //FAQ
    $('.list').on('click', function() {
        var box = $(this).next('.answer_box');

        if(box.is(":visible")) {
            box.hide();
        }else{
            box.show()
        }
    });

    $('#mainIframe', parent.document).css('height', document.body.scrollHeight);
});

