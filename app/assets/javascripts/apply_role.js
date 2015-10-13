/**
 * Created by huaxiukun on 15/8/18.
 */
$(function () {
    $('.apply-role-start').on('click', function () {
        var role_id = $(this).attr('data-id');
        var user_id = $('#user-id').val();

        if (user_id) {
            $.ajax({
                url: 'apply_roles/apply_role',
                data: {"role_id": role_id},
                type: 'post',
                success: function (data) {
                    if (data[0]) {
                        alert('ok');
                    } else {
                        alert('fail');
                    }
                }
            })

        }
    });
});