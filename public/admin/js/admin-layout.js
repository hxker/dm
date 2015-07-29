/**
 * Created by l on 15-7-29.
 */
$(function(){
    if($.cookie('menu-min')==1){
        $('.sidebar').addClass('menu-min');
    }else{
        $('.sidebar').removeClass('menu-min');
    }
    $('#sidebar-collapse').on('click',function(){
        if($('.sidebar').hasClass('menu-min')){
            $.cookie('menu-min',1,{path: '/'});
        }else{
            $.cookie('menu-min',0,{path: '/'});
        };
    })
});