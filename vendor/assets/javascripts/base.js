/**
 * Created by jason on 15-9-28.
 */
$(function () {
    if ($('body').height() < $(window).height()) {
        $('.floor').height($(window).height());
    }

    if($('#edit_avatar')){
        $('#edit_avatar')on('click',function(event){
            eventpreventDefault();
            alert();
        })
    }
});