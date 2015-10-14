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
                var option = {
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
                };
                ajaxHandle(option);
            })
        }

        if ('#check_profile') {
            $('.btn-save-profile').on('click', function (event) {
                event.preventDefault();
                var form = $(this).parents('form');
                var option = {
                    url: form.attr('data-url'),
                    type: form.attr('data-method'),
                    data: form.serialize(),
                    success: function (data) {
                        if (data[0]) {
                            alert(data[1]);
                            $('#check_profile').modal('hide');
                            $('#apply_in_competition').modal('show');
                            $("#page").page({
                                remote: {
                                    url: '/competitions/event_teams',  //请求地址
                                    params: { id: $('.competitions-tab.active').attr('data-id')},       //自定义请求参数
                                    success: function (data, pageIndex) {
                                        //回调函数
                                        //result 为 请求返回的数据，呈现数据
                                        console.log(data);
                                    },
                                    pageIndexName: 'page',     //请求参数，当前页数，索引从0开始
                                    pageSizeName: 'per',       //请求参数，每页数量
                                    totalName: 'total'
                                },
                                pageSize:9,
                            });


                        } else {
                            alert(data[1]);
                        }
                    }
                };
                ajaxHandle(option);
            })
        }
    }
);

function get_teams(page, num) {
    var data = {
        id: $('.competitions-tab.active').attr('data-id'),
        page: page,
        num: num
    };
    var option = {
        url: '/competitions/event_teams',
        type: 'get',
        data: data,
        success: function (result) {
            console.log(result);
            //替换dom
            replaceDom('.team-list', result[0]);
        }
    };
    ajaxHandle(option);
}

function replaceDom(selector, data) {
    $(selector).empty();
    $.each(data, function () {
        var _dom = '<div class="team-item">' +
            '<div class="team-pic">' +
            '<img src="' + data.team_img + '" alt=""/>' +
            '</div>' +
            '<div class="team-dec">' +
            '<p class="t-16 blue">' + data.team_name + '</p>' +
            '<p class="t-14">' + data.team_autograph + '</p>' +
            '<button data-id="' + data.team_id + '" class="btn-join-team">加入战队</button>' +
            '</div></div>';
        $(_dom).appendTo(selector);
    });
}


function ajaxHandle(option) {
    $.ajax(option);
}


/*   /competitions/event_teams?id=<%eventid%>&page=<%page%>    */