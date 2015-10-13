/**
 * Created by jason on 15-9-28.
 */
$(function () {
    if ($('body').height() < $(window).height()) {
        $('.floor').height($(window).height());
    }

    if ($('#competition')) {
        $('#competition-items').find('.item').on('click', function () {
            $('.competitions-tab').removeClass('active').eq($(this).index()).addClass('active');
        })
    }

    if ($('.apply-menu-sub')) {
        $('.apply-menu-sub').on('click', function () {
            $(this).parent().find('.apply-menu-sub').removeClass('active');
            $(this).addClass('active');
            $('.apply-content-sub').removeClass('active');
            $('.apply-content-sub').eq($(this).index()).addClass('active');
        });
    }

    if ('#create_team') {
        $('#create_team').on('click', function () {
            var form_data = {
                event_id: $('.competitions-tab.active').attr('data-id'),
                team_name: $("input[name='team-name']").val(),
                team_code: $("input[name='team-code']").val(),
                teacher: $("input[name='team-teacher']").val()
            };

            $.ajax({
                url: '/competitions/valid_create_team',
                type: 'post',
                data: form_data,
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.reload();

                    } else {
                        alert(data[1]);
                    }
                }
            });
        })
    }
});