/**
 * Created by l on 15-7-29.
 */
$(function () {

    //cookie保存菜单状态
    if ($.cookie('menu-min') == 1) {
        $('.sidebar').addClass('menu-min');
    } else {
        $('.sidebar').removeClass('menu-min');
    }
    $('#sidebar-collapse').on('click', function () {
        if ($('.sidebar').hasClass('menu-min')) {
            $.cookie('menu-min', 1, {path: '/'});
        } else {
            $.cookie('menu-min', 0, {path: '/'});
        }
    });

    //消息提示框
    if ($('#notice').length > 0) {
        $.gritter.add({
            title: '提醒',
            text: $('#notice').text(),
            time: '5000'
        });
    }

    //时间控件
    $('input[data-control="dateForm"]').datepicker({
        autoclose: true
    });
    $('input[data-control="timeForm"]').timepicker({
        minuteStep: 1,
        showSeconds: true,
        showMeridian: false
    });
    //时间组件合并
    var dateMerge = $('[data-date-merge]');
    if (dateMerge.length > 0) {
        $.each(dateMerge,function(){
            var self = $(this);
            var date = self.find('input[data-date-merge-date]');
            var time = self.find('input[data-date-merge-time]');
            var result = self.find('input[data-date-merge-result]');
            date.on('change', function () {
                var d = date.val();
                var t = time.val();
                result.val(d+' '+t);
            });
            time.on('change', function () {
                var d = date.val();
                var t = time.val();
                result.val(d+' '+t);
            });
        })
    }
});