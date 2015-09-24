//$(function () {
//    $('.register-email').blur(function () {
//        var register_email = $('.register-email').val();
//        var email = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
//        if (email.test(register_email)) {
//            $.ajax({
//                url: '/accounts/register_email_exists',
//                type: 'post',
//                data: {"email": register_email},
//                dataType: 'json',
//                success: function (data) {
//                    if (data) {
//                        $('.email-exists').removeClass('hidden');
//                        $('.error').text('该邮箱已经被注册');
//
//                    } else {
//                        $('.email-exists').addClass('hidden');
//                        $('.error').text('');
//                    }
//                }
//            });
//        }
//        else if (register_email == '') {
//            $('.email-exists').removeClass('hidden');
//            $('.error').text('邮箱不能为空');
//        }
//        else {
//            $('.email-exists').removeClass('hidden');
//            $('.error').text('邮箱格式不正确');
//            $('.register-email').focus();
//            return false;
//        }
//    });
//});
