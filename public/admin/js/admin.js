/**
 * Created by huaxiukun on 15/8/2.
 */
$(function () {
    $('.btn-search-toggle').on('click', function () {
        $('.form-search-toggle').toggleClass('hide show');
    });
    $('#score_competition_id').on('change', function () {
        var competition_id = $('#score_competition_id').val();
        $.ajax({
            url: '/admin/scores/get_teams',
            type: 'post',
            data: {"competition_id": competition_id},
            dataType: 'json',
            success: function (data) {
                if (data.length != 0) {
                    $.each(data, function (key, val) {
                        var option = $('<option value="' + val.id + '" >' + val.name + '</option>');
                        $('#score_team1_id,#score_team2_id').append(option);
                    });
                }
                else {
                    alert('获取队伍失败或该比赛还没有队伍报名');
                }

            }
        })
    });

    $('#score_kind').on('change', function () {
        var score_kind = $('#score_kind').val();
        if (score_kind == '1') {
            $('.score_team2_id,.score_score2').addClass('hidden');
        } else {
            $('.score_team2_id,.score_score2').removeClass('hidden');
        }
    });
    $('.add-mark-score').on('click', function () {
        var score_kind = $('#score_kind').val();
        if (score_kind == '1') {
            $('#score_team2_id').val($('#score_team1_id').val());
            $('#score_score2').val($('#score_score1').val());
        }
    });

    $('.open-add-team').on('click', function () {
        $('.start-add-team').slideToggle();
    });

    var chosen_select = $(".chosen-select");
    chosen_select.chosen();

    // 创建队伍
    $('.create-team-submit').on('click', function () {

        var event_id = $(this).attr('data-id');
        var team_name = trim($(".team-info [name='team-name']").val());
        var team_code = trim($(".team-info [name='team-code']").val());
        var teacher = trim($(".team-info [name='team-teacher']").val());
        var user_id = $("#select-team-leader option:selected").val();

        if ((team_name.length > 6) || (team_name.length < 2)) {
            alert('请输入2-6位的队伍名称');
            $(".team-info [name='team-name']").focus();
            return false;
        }
        if ((team_code.length > 6) || (team_code.length < 4)) {
            alert('请输入4-6位的队伍密钥');
            $(".team-info [name='team-code']").focus();
            return false;
        }
        if (teacher == '') {
            alert('请输入指导教师');
            $(".team-info [name='team-teacher']").focus();
            return false;
        }
        if (user_id == '') {
            alert('请选择队长');
            $("＃select-team-leader").focus();
            return false;
        }
        if (event_id != null) {
            $.ajax({
                url: '/admin/events/create_team',
                type: 'post',
                data: {
                    "event_id": event_id,
                    "team_code": team_code,
                    "team_name": team_name,
                    "user_id": user_id,
                    "teacher": teacher
                },
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.reload();
                    } else {
                        bootbox.alert(data[1]);
                    }
                }
            });
        }
    });


    $('.dd').nestable();
    var max_num = $('.team-max-num').text();
    if (max_num == 1) {
        $('.event-team').slimScroll({
            height: '42px',
            alwaysVisible: true
        });
    } else if (max_num == 2) {
        $('.event-team').slimScroll({
            height: '85px',
            alwaysVisible: true
        });
    } else if (max_num == 3) {
        $('.event-team').slimScroll({
            height: '123px',
            alwaysVisible: true
        });
    } else {
        $('.event-team').slimScroll({
            height: '163px',
            alwaysVisible: true
        });
    }
    //$.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
    //    _title: function (title) {
    //        var $title = this.options.title || '&nbsp;';
    //        if (("title_html" in this.options) && this.options.title_html == true)
    //            title.html($title);
    //        else title.text($title);
    //    }
    //}));

    $('.open-add-player').on('click', function () {
        var team_id = $(this).attr('data-id');
        var team_name = $(this).attr('data-name');
        $('#add-player-team-id').val(team_id);
        $('.team-name').text(team_name);
    });

    $('#modal-form,#add-team-form').on('shown.bs.modal', function () {
        $(this).find('.chosen-container').each(function () {
            $(this).find('a:first-child').css('width', '320px');
            $(this).find('.chosen-drop').css('width', '320px');
            $(this).find('.chosen-search input').css('width', '310px');

        });
        $(this).find('.chosen-container-multi').css('width', '320px');
        $(this).find('.team-name-foc').focus();
    });

    // 添加队员
    $('.add-player-submit').on('click', function () {
        var user_ids = $("#window-select-team-player").val();
        var team_id = $('#add-player-team-id').val();
        var max_num = $('.team-max-num').text();
        var team_players = document.getElementById(team_id).innerHTML;
        var rest = max_num - team_players;
        if (user_ids.length > rest) {
            alert('该队只能再添加' + rest + '人!');
            return false;
        } else if (user_ids.length > 4) {
            alert('一次只能添加4人!' + user_ids.length);
            return false;
        }
        //var event_id = $(this).attr('data-name');
        $.ajax({
            url: '/admin/events/add_team_player',
            type: 'post',
            data: {
                "team_id": team_id,
                "user_ids": user_ids
                //"event_id": event_id
            },
            success: function (data) {
                if (data[0]) {
                    if (data[1].indexOf('添加失败') >= 0) {
                        alert(data[1]);
                    } else {
                        var ok = data[1].split('添加成功');
                        alert(ok + ' 添加成功');
                    }
                    window.location.reload();
                } else {
                    alert(data[1]);
                }
            }
        });
    });

    //删除队员
    $('.delete-team-player-a').on('click', function () {
        var player = $(this).attr('data-text');
        var user_id = $(this).attr('data-name');
        var team_id = $(this).attr('data-id');
        bootbox.confirm('确认删除队员 —— ' + player + '?', function (result) {
            if (result) {

                $.ajax({
                    url: '/admin/events/delete_team_player',
                    type: 'post',
                    data: {
                        "team_id": team_id,
                        "user_id": user_id
                    },
                    success: function (data) {
                        if (data[0]) {
                            $("#hide-player-" + user_id).addClass('hide');
                            bootbox.dialog({
                                message: data[1],
                                buttons: {
                                    "success": {
                                        "label": "OK",
                                        "className": "btn-sm btn-primary"
                                    }
                                }
                            });
                        } else {
                            alert(data[1]);
                        }
                    }
                });
            }
        });
    });

    //删除队伍
    $('.admin-delete-team').on('click', function () {
        var team_name = $(this).attr('data-name');
        var team_id = $(this).attr('data-id');
        bootbox.confirm('确认删除' + team_name + '?', function (result) {
            if (result) {

                $.ajax({
                    url: '/admin/events/delete_team',
                    type: 'post',
                    data: {
                        "team_id": team_id
                    },
                    success: function (data) {
                        if (data[0]) {
                            $("#hide-team-" + team_id).addClass('hide');
                            bootbox.dialog({

                                message: data[1],
                                buttons: {
                                    "success": {
                                        "label": "OK",
                                        "className": "btn-sm btn-primary"
                                    }
                                }
                            });
                        } else {
                            alert(data[1]);
                        }
                    }
                });
            }
        });
    });

    $('.add-expert-score').on('click', function () {
        var activity_id = $(this).attr('data-id');
        bootbox.prompt({
            title: '专家评分:',
            //message: '专家评分:',
            size: 'small',
            callback: function (result) {
                var exp = /^(0|[0-9])+(\.[0-9]+)?$/;
                if (exp.test(result)) {

                    $.ajax({
                        url: '/admin/creative_activities/add_expert_score',
                        type: 'post',
                        data: {
                            "activity_id": activity_id,
                            "expert_score": result
                        },
                        success: function (data) {
                            if (data[0]) {
                                bootbox.alert({
                                    size: 'small',
                                    message: data[1]
                                });
                                document.getElementById('add-expert-score').innerHTML = result;
                                document.getElementById('last-score' + activity_id).innerHTML = parseInt(document.getElementById('like-count' + activity_id).innerHTML) + parseFloat(result);
                                var score = $('.add-expert-score');
                                score.removeClass('btn-warning');
                                score.addClass('btn-info');
                            } else {
                                alert(data[1]);
                            }
                        }
                    });
                } else if (result != null) {
                    alert('请正确输入非负数的分数!');
                }
            }
        });
    });

    $('.edit-expert-score').on('click', function () {
        var activity_id = $(this).attr('data-id');
        var score = document.getElementById('edit-expert-score' + activity_id).innerHTML;
        bootbox.prompt({
            title: '更改专家评分:',
            size: 'small',
            value: score,
            callback: function (result) {
                var exp = /^(0|[0-9])+(\.[0-9]+)?$/;
                if (exp.test(result)) {
                    $.ajax({
                        url: '/admin/creative_activities/edit_expert_score',
                        type: 'post',
                        data: {
                            "activity_id": activity_id,
                            "expert_score": result
                        },
                        success: function (data) {
                            if (data[0]) {
                                bootbox.alert({
                                    size: 'small',
                                    message: data[1]
                                });
                                document.getElementById('edit-expert-score' + activity_id).innerHTML = result;
                                document.getElementById('last-score' + activity_id).innerHTML = parseInt(document.getElementById('like-count' + activity_id).innerHTML) + parseFloat(result);
                            } else {
                                alert(data[1]);
                            }
                        }
                    });
                } else if (result != null) {
                    alert('请正确输入非负数的分数!');
                }
            }
        });
        //bootbox.prompt('更改专家评分:',score, function (result) {
        //    var exp = /^(0|[0-9])+(\.[0-9]+)?$/;
        //    if (exp.test(result)) {
        //        $.ajax({
        //            url: '/admin/creative_activities/edit_expert_score',
        //            type: 'post',
        //            data: {
        //                "activity_id": activity_id,
        //                "expert_score": result
        //            },
        //            success: function (data) {
        //                if (data[0]) {
        //                    bootbox.alert(data[1]);
        //                    document.getElementById('edit-expert-score').innerHTML = result;
        //                } else {
        //                    alert(data[1]);
        //                }
        //            }
        //        });
        //    } else if (result != null) {
        //        alert('请正确输入非负数的分数!');
        //    }
        //});


    });
    $('.audit-user-activity').on('click', function () {
        var activity_id = $(this).attr('data-id');
        var message = '<div id="audio-window"><label class="radio-inline"> <input type="radio" name="audio-activity" id="audio-activity" value="1"> 通过</label>&nbsp;&nbsp;<label class="radio-inline"> <input type="radio" name="audio-activity" id="audio-activity" value="2"> 不通过</label></div>';
        bootbox.dialog({
            title: '审核作品:',
            message: message,
            size: 'small',
            buttons: {
                'success': {
                    "label": "<i class='icon-ok'></i> 提交",
                    "className": "btn-sm btn-primary",
                    "callback": function () {
                        var status = $('input:radio[name="audio-activity"]:checked').val();
                        if (status == null || status == '') {
                            alert('请选择审核结果!');
                            return false;
                        } else {
                            $.ajax({
                                url: '/admin/creative_activities/audit',
                                type: 'POST',
                                data: {
                                    "activity_id": activity_id,
                                    "status": status
                                },
                                success: function (data) {
                                    if (data[0]) {
                                        bootbox.dialog({
                                            message: data[1],
                                            buttons: {
                                                "success": {
                                                    "label": "OK",
                                                    "className": "btn-sm btn-primary"
                                                }
                                            }
                                        });
                                        var audio = $('.audit-user-activity');
                                        audio.removeClass('btn-info');
                                        //console.log($('.audit-user-activity').text());
                                        if (status == 1) {
                                            audio.text('通过');
                                            audio.addClass('btn-primary');
                                        } else {
                                            audio.text('未通过');
                                            audio.addClass('btn-danger');
                                        }

                                    } else {
                                        alert(data[1]);
                                    }
                                }
                            });
                        }
                    }
                }
            }
        });
    });


    //切换审核作品结果
    $('.switch-audit-user-activity').on('click', function () {
        var activity_id = $(this).attr('data-id'), status;
        if ($('.switch-audit-user-activity').text() == '通过') {
            status = 2;
        } else {
            status = 1
        }
        bootbox.confirm('确认将审核结果改为' + (status == 2 ? '不' : '') + '通过?', function (result) {
            if (result) {

                $.ajax({
                    url: '/admin/creative_activities/audit',
                    type: 'POST',
                    data: {
                        "activity_id": activity_id,
                        "status": status
                    },
                    success: function (data) {
                        if (data[0]) {

                            bootbox.dialog({
                                message: data[1],
                                buttons: {
                                    "success": {
                                        "label": "OK",
                                        "className": "btn-sm btn-primary"
                                    }
                                }
                            });
                            var audio = $('.switch-audit-user-activity');
                            if (status == 1) {
                                audio.text('通过');
                                audio.removeClass('btn-danger');
                                audio.addClass('btn-primary');
                            } else {
                                audio.text('未通过');
                                audio.removeClass('btn-primary');
                                audio.addClass('btn-danger');
                            }

                        } else {
                            alert(data[1]);
                        }
                    }
                });
            }
        });
    });

});
//删除两边空格
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}
//删除左边的空格
function ltrim(str) {
    return str.replace(/(^\s*)/g, "");
}
//删除右边的空格
function rtrim(str) {
    return str.replace(/(\s*$)/g, "");
}