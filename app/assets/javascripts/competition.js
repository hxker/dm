/**
 * Created by huaxiukun on 15/8/5.
 */

$(function () {


    $('.reset-by-mobile').on('click', function () {
        var team_id = $(this).attr('data-id');
        var mobile = $(this).attr('data-name');

        BootstrapDialog.show({
            title: '重置队伍密钥:',
            message: ' <div class="row">' +
            '<div class="col-sm-12">' +
            '<input type="text" id="leader_mobile" class="form-control" value="' + mobile + '" disabled><br>' +
            '<div class="row">' +
            '<div class="form-group tel required  col-md-12">' +
            '<input id="leader_mobile_code" class="form-control" type="tel" placeholder="请输入手机验证码">' +
            '</div></div>' +
            '<input type="text" value="" id="new_team_code" placeholder="请输入队伍新密钥" class="form-control"><br>' +
            '</div></div>',

            cssClass: 'login-dialog',
            buttons: [
                // 获取手机验证码按钮
                {
                    label: '获取验证码',
                    hotkey: 27, // 按 'esc' 键取消修改
                    action: function () {
                        if (!isNaN(mobile)) {
                            // 提交请求
                            $.ajax({
                                url: '/accounts/send_code',
                                type: 'post',
                                data: {
                                    "mobile": mobile,
                                    "type": 'RESET_TEAM_CODE',
                                    "ip": 'ip_address'
                                },
                                success: function (data) {
                                    // 发送成功提示信息
                                    alert(data[1]);
                                },
                                error: function (data) {
                                    alert('12');
                                    alert(data[1]);
                                }
                            });
                        }
                    }
                },
                {
                    label: '提交(enter)',
                    cssClass: 'btn-primary',
                    hotkey: 13, // 按 'enter' 键发送修改请求
                    // 点击提交按钮后的动作
                    action: function (dialogItself) {
                        var new_team_code = $('#new_team_code').val();
                        var mobile_code = $('#leader_mobile_code').val();
                        // 提交请求
                        $.ajax({
                            url: '/competitions/reset_team_code_by_mobile',
                            type: 'post',
                            data: {
                                "new_team_code": new_team_code,
                                "team_id": team_id,
                                "mobile_code": mobile_code,
                                "mobile": mobile
                            },
                            success: function (data) {
                                if (data[0]) {
                                    // 重置成功提示信息
                                    alert(data[1]);
                                    dialogItself.close();
                                }
                                else {
                                    alert(data[1]);
                                }
                            }
                        });

                    }
                }

            ]
        });
    });
    // 通过邮箱重置队伍密钥
    $('.reset-by-email').on('click', function () {
        var team_id = $(this).attr('data-id');
        var email = $(this).attr('data-name');

        BootstrapDialog.show({
            title: '重置队伍密钥:',
            message: ' <div class="row">' +
            '<div class="col-sm-12">' +
            '<input type="text" id="leader_email" class="form-control" value="' + email + '" disabled><br>' +
            '<div class="row">' +
            '<div class="form-group tel required  col-md-12">' +
            '<input id="leader_email_code" class="form-control" type="tel" placeholder="请输入邮箱验证码">' +
            '</div></div>' +
            '<input type="text" value="" id="new_team_code" placeholder="请输入队伍新密钥" class="form-control"><br>' +
            '</div></div>',

            cssClass: 'login-dialog',
            buttons: [
                // 获取邮箱验证码按钮
                {
                    label: '发送验证码到邮箱',
                    hotkey: 27, // 按 'esc' 键取消修改
                    action: function () {
                        if (email != null) {
                            // 提交请求
                            $.ajax({
                                url: '/competitions/send_email_code',
                                type: 'post',
                                data: {
                                    "team_id": team_id,
                                    "email": email,
                                    "type": 'RESET_TEAM_CODE',
                                    "ip": 'ip_address'
                                },
                                success: function (data) {
                                    // 发送成功提示信息
                                    alert(data[1]);
                                },
                                error: function (data) {
                                    alert(data[1]);
                                }
                            });
                        }
                    }
                },
                {
                    label: '提交(enter)',
                    cssClass: 'btn-primary',
                    hotkey: 13, // 按 'enter' 键发送修改请求
                    // 点击提交按钮后的动作
                    action: function (dialogItself) {
                        var new_team_code = $('#new_team_code').val();
                        var email_code = $('#leader_email_code').val();
                        // 提交请求
                        if (email_code != null) {
                            $.ajax({
                                url: '/competitions/reset_team_code_by_email',
                                type: 'post',
                                data: {
                                    "new_team_code": new_team_code,
                                    "team_id": team_id,
                                    "email_code": email_code,
                                    "email": email
                                },
                                success: function (data) {
                                    if (data[0]) {
                                        // 重置成功提示信息
                                        alert(data[1]);
                                        dialogItself.close();
                                    }
                                    else {
                                        alert(data[1]);
                                    }
                                }
                            });
                        }

                    }
                }

            ]
        });
    });


    // 补全确认报名所需信息
    $('.full-apply-info').on('click', function () {
        $(".full-apply").slideToggle();
        $('.add-apply-info').on('click', function () {
            var user_id = $(this).attr('data-id');
            var username = $('.true-name').val();
            var age = $('.true-age').val();
            var school = $('.true-school').val();
            var grade = $('.true-grade').val();

            //if ((username.length > 4) || (username.length < 2)) {
            //    alert('请输入2-4位的真实姓名');
            //    $(".true-name").focus();
            //    return false;
            //}
            //if (age) {
            //    alert('请正确输入年龄');
            //    $(".true-age").focus();
            //    return false;
            //}
            //if (school) {
            //    alert('学校不能为空');
            //    $(".true-school").focus();
            //    return false;
            //}
            //if (grade) {
            //    alert('班级不能为空');
            //    $(".true-grade").focus();
            //    return false;
            //}
            if (!isNaN(user_id)) {
                $.ajax({
                    url: '/competitions/add_user_apply_info',
                    type: 'post',
                    data: {"user_id": user_id, "username": username, "age": age, "school": school, "grade": grade},
                    success: function (data) {
                        if (data[0]) {
                            alert(data[1]);
                            $(".full-apply").slideToggle();
                            $(".start-apply").slideToggle();
                        } else {
                            alert(data[1]);
                        }
                    }
                });
            }
        });
    });

    // 创建队伍
    $('.create-team-submit').on('click', function () {
        var event_id = $(this).attr('data-id');
        var team_name = $(".team-info [name='team-name']").val();
        var team_code = $(".team-info [name='team-code']").val();

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

        if (event_id != null) {
            $.ajax({
                url: '/competitions/valid_create_team',
                type: 'post',
                data: {
                    "competition_id": event_id,
                    "team_code": team_code,
                    "team_name": team_name
                },
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.reload();

                    } else {
                        alert(data[1]);
                    }
                }
            });
        }
    });

    // 申请加入该队
    $('.apply-into-team').on('click', function () {
        var user_id = $(this).attr('data-id');
        var team_id = $(this).attr('data-name');
        var event_id = $(this).attr('data-event');

        if (!isNaN(user_id)) {
            $(".full-apply").slideToggle();
            $('.add-apply-info').on('click', function () {
                var user_id = $(this).attr('data-id');
                var username = $('.true-name').val();
                var age = $('.true-age').val();
                var school = $('.true-school').val();
                var grade = $('.true-grade').val();
                if ((username.length > 4) || (username.length < 2)) {
                    alert('请输入2-4位的真实姓名');
                    $(".true-name").focus();
                    return false;
                }
                //if (age) {
                //    alert('请正确输入年龄');
                //    $(".true-age").focus();
                //    return false;
                //}
                //if (school) {
                //    alert('学校不能为空');
                //    $(".true-school").focus();
                //    return false;
                //}
                //if (grade) {
                //    alert('班级不能为空');
                //    $(".true-grade").focus();
                //    return false;
                //}
                if (!isNaN(user_id)) {
                    $.ajax({
                        url: '/competitions/add_user_apply_info',
                        type: 'post',
                        data: {"user_id": user_id, "username": username, "age": age, "school": school, "grade": grade},
                        success: function (data) {
                            if (data[0]) {
                                alert(data[1]);
                                $(".full-apply").slideToggle();
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
                                                        "team_id": team_id,
                                                        "event_id": event_id
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
                            } else {
                                alert(data[1]);
                            }
                        }
                    });
                }
            });


        }
    });
    // 队员退出队伍
    $('.reduce-team-amount').on('click', function () {
        var team_id = $(this).attr('data-name');
        var value = confirm('确认退出该队吗？');
        if (!isNaN(team_id) && value) {
            $.ajax({
                url: '/competitions/reduce_team_amount',
                type: 'post',
                data: {"id": team_id},
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.href = '/user/comp'
                    } else {
                        alert(data[1]);
                    }
                }
            });
        }
    });
    // 队长解散队伍
    $('.leader-delete-team').on('click', function () {
        var team_id = $(this).attr('data-name');
        var value = confirm('确认解散该队吗？');
        if (!isNaN(team_id) && value) {
            $.ajax({
                url: '/competitions/delete_team',
                type: 'post',
                data: {"id": team_id},
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.href = '/user/comp'
                    } else {
                        alert(data[1]);
                    }
                }
            });
        }
    });

});