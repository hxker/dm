/**
 * Created by jason on 15-9-28.
 */
$(function () {
        if ($('body').height() < $(window).height()) {
            $('.floor').height($(window).height() - 120);
        }

        if ($('#competition-detail').length > 0) {
            $('.head-item').on('click', function (event) {
                event.preventDefault();
                if (!$(this).hasClass('active')) {
                    $(this).addClass('active').siblings('.head-item').removeClass('active');
                    var index = $(this).index();
                    $('.head-item-sub').eq(index).addClass('active').siblings('.head-item-sub').removeClass('active');
                }
            })
        }

        if ($('#random_name').length > 0) {
            var random_name = {
                status: "true",
                data: [
                    "梦之队",
                    "梦想之队",
                    "乐思",
                    "格兰芬多",
                    "擎天柱",
                    "赛博坦",
                    "大黄蜂",
                    "金刚",
                    "泰坦",
                    "银色渡鸦",
                    "自由之翼",
                    "终结者",
                    "小萝卜头",
                    "机械迷城",
                    "青蛙王子",
                    "长江七号",
                    "SATAN",
                    "纳米核心",
                    "钢羽",
                    "东方",
                    "银河漫游",
                    "Angel",
                    "灰色金属",
                    "SuperMan",
                    "钢铁侠",
                    "东方荣耀"
                ]
            };
            $('#random_name').val(random_name.data[Math.round(Math.random() * (random_name.data.length - 1))]);
            $('#random_effect').on('click',function(){
                $('#random_name').val(random_name.data[Math.round(Math.random() * (random_name.data.length - 1))]);
            });
        }

        if ($('#competition').length > 0) {
            $('#competition-items').find('.item').on('click', function () {
                $('.competitions-tab').removeClass('active').eq($(this).index()).addClass('active');
            })
        }

        if ($('.apply-menu-sub').length > 0) {
            $('.apply-menu-sub').on('click', function () {
                $(this).parent().find('.apply-menu-sub').removeClass('active');
                $(this).addClass('active');
                $('.apply-content-sub').removeClass('active');
                $('.apply-content-sub').eq($(this).index()).addClass('active');
            });
        }

        if ($('#create_team').length > 0) {
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

        if ($('[data-edit]').length > 0) {
            editInput.init('[data-edit]', {});
        }

        if ($('#check_profile').length > 0) {
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
                            get_teams()
                        } else {
                            alert(data[1]);
                        }
                    }
                };
                ajaxHandle(option);
            })
        }

        if ($('#homepage').length > 0) {
            var homepageSwiper = new Swiper('.swiper-container', {
                direction: 'horizontal',
                loop: true,
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                pagination: '.swiper-pagination',
                paginationClickable: true,
                autoplay: 5000
            })
        }

        if ($('.news-banner').length > 0) {
            var mySwiper = new Swiper('.swiper-container', {
                direction: 'horizontal',
                loop: true,
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                paginationClickable: true,
                autoplay: 5000
            });
            $('.thumb-menu>.items>.item').on('click', function () {
                if (!$(this).hasClass('active')) {
                    $(this).addClass('active').siblings('.item').removeClass('active');
                    var index = $(this).index();
                    mySwiper.slideTo(index + 1, 400, function () {
                    });
                }
            });
        }
    }
);

function get_teams(text) {
    var params = {id: $('.competitions-tab.active').attr('data-id')};
    if (text) {
        params.team_name = text;
    }
    $("#page").children().remove();
    $("#page").page({
        remote: {
            url: '/competitions/event_teams',  //请求地址
            params: params,       //自定义请求参数
            callback: function (data, pageIndex) {
                //回调函数
                //result 为 请求返回的数据，呈现数据
                //console.log(data);
                replaceDom('.team-list', data[0]);
            },
            pageIndexName: 'page',     //请求参数，当前页数，索引从0开始
            pageSizeName: 'per',       //请求参数，每页数量
            totalName: '1'             //total字段名
        },
        pageSize: 1 //每页数量
    });
}

function replaceDom(selector, data) {
    $(selector).empty();
    // name 队伍名称
    // team_players 队伍已有人数
    // team_leader 队长昵称
    // cover 队伍头像
    if (data.length > 0) {
        var limit = $('#team-limit').val();
        for (var i = 0; i < data.length; i++) {
            var btn = "";
            limit > data[i].team_players ? btn = '<button data-id="' + data[i].id + '" class="btn-join-team">加入战队</button>' : btn = '<span class="label label-warning t-14">人数已满</span>';
            var _dom = '<div class="team-item">' +
                '<div class="team-pic">' +
                '<img src="' + data[i].cover + '" alt=""/>' +
                '</div>' +
                '<div class="team-dec">' +
                '<p class="t-16 blue">' + data[i].name + '</p>' +
                '<p class="t-14">' + data[i].team_leader + '</p>' + btn +
                '</div></div>';
            $(_dom).appendTo(selector);
        }
    } else {
        var _dom1 = '<div class="team-item">' +
            '没有相关队伍</div>';
        $(_dom1).appendTo(selector);
    }

    $('.btn-join-team').on('click', function () {
        var team_id = $(this).attr('data-id');
        BootstrapDialog.show({
            title: '请输入该队队长设置的密钥:',
            message: ' <input type="text" value="" id="valid_team_code"  class="form-control">',
            cssClass: 'login-dialog',
            buttons: [
                {
                    label: '提交(enter)',
                    cssClass: 'btn-primary',
                    hotkey: 13, // 按 'enter' 键发送修改请求
                    // 点击提交按钮后的动作
                    action: function () {
                        var team_code = $('#valid_team_code').val();
                        // 提交请求
                        $.ajax({
                            url: '/competitions/valid_team_code',
                            type: 'post',
                            data: {
                                "team_code": team_code,
                                "team_id": team_id
                            },
                            success: function (data) {
                                if (data[0]) {
                                    // 申请成功提示信息
                                    alert(data[1]);
                                    window.location.reload();
                                }
                                else {
                                    alert(data[1]);
                                }
                            }
                        });

                    }
                },
                // 取消更改按钮
                {
                    label: '取消(esc)',
                    hotkey: 27, // 按 'esc' 键取消修改
                    action: function (dialogItself) {
                        dialogItself.close();
                    }
                }
            ]
        });
        //console.log(team_id);
    });
}

$('#select-team-action').on('click', function (event) {
    event.preventDefault();
    get_teams($('#search-team-name').val());
});
function ajaxHandle(option) {
    $.ajax(option);
}

var editInput = {
    option: {},
    init: function (selector, option) {
        this.option = option;
        $.each($(selector), function (k, v) {
            $(v).addClass('clickMe').on('click', function () {
                option.name = $(v).attr('data-name');
                editInput.changeInput($(v), option);
            });
        })
    },
    changeInput: function (v, option) {
        $(v).css({display: 'none'});
        var input = $('<input>').addClass('editInput').val($.trim($(v).text()));
        input.insertAfter(v);
        input.focus();
        input.on('blur', function () {
            var val = $(this).val();
            $(v).text($.trim(val)).css({display: ''});
            $('input[name="' + option.name + '"]').val($.trim(val));
            $(this).remove();
        })
    }
};


/*   /competitions/event_teams?id=<%eventid%>&page=<%page%>    */