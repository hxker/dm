/**
 * Created by huaxiukun on 15/9/14.
 */
//(function () {
$(function () {
    var is_sending;
    is_sending = false;
    $('#btn_send_mobile_code').click(function () {
        var mobile, captcha, mobile_number, self;
        self = $(this);
        if (is_sending) {
            return;
        }
        mobile = $('#' + self.attr('data-key') + '_mobile');
        captcha = $('input[name="captcha"]').val();
        mobile_number = mobile.val();
        if (mobile_number === '' || mobile_number.length !== 11 || isNaN(mobile_number)) {
            alert('手机号码格式不正确');
            mobile.focus();
            return;
        }
        if (captcha == '' || captcha == null) {
            alert('请输入校验码');
            $('input[name="captcha"]').focus();
            return;
        } else {

            $.ajax({
                url: '/accounts/validate_captcha',
                type: 'POST',
                data: {"captcha": captcha},
                success: function (data) {

                    if (data[0]) {
                        console.log(data[1]);
                        self.blur();
                        is_sending = true;
                        self.text('发送中...').addClass('disabled');
                        return $.ajax({
                            url: '/accounts/send_code',
                            type: 'POST',
                            data: {
                                "mobile": mobile_number,
                                "type": self.attr('data-type'),
                                "ip": 'ip_address'
                            },
                            success: function (data) {
                                return alert(data[1]);
                            },
                            error: function (data) {
                                return alert(data[1]);
                            },
                            complete: function () {
                                is_sending = false;
                                return self.text('获取验证码').removeClass('disabled');
                            }
                        });
                    } else {
                        alert(data[1]);
                    }
                    var src = $("img[alt='captcha']").attr('src');
                    $('#captcha-plus').find('img').attr('src', String(src.split('i=')[0]) + 'i=' + String(parseInt(src.split('i=')[1]) + 2));
                }

            });
        }

    });
    $('.refresh-captcha').on('click', function () {
        var src = $("img[alt='captcha']").attr('src');
        $('#captcha-plus').find('img').attr('src', String(src.split('i=')[0]) + 'i=' + String(parseInt(src.split('i=')[1]) + 1));
    });
});

//}).call(this);
