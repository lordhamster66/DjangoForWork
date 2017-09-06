/**
 * Created by Administrator on 2017/9/3.
 */
$(function () {

    $('#switch_qlogin').click(function () {
        $('#switch_login').removeClass("switch_btn_focus").addClass('switch_btn');
        $('#switch_qlogin').removeClass("switch_btn").addClass('switch_btn_focus');
        $('#switch_bottom').animate({left: '0px', width: '70px'});
        $('#qlogin').css('display', 'none');
        $('#web_qr_login').css('display', 'block');

    });
    $('#switch_login').click(function () {

        $('#switch_login').removeClass("switch_btn").addClass('switch_btn_focus');
        $('#switch_qlogin').removeClass("switch_btn_focus").addClass('switch_btn');
        $('#switch_bottom').animate({left: '154px', width: '70px'});

        $('#qlogin').css('display', 'block');
        $('#web_qr_login').css('display', 'none');
    });
});


$(function () {
    $.ajaxSetup({
        beforesend: function (xhr, settings) {
            xhr.setRequestHeader("X-CSRFtoken", $.cookie("csrftoken"))
        }
    });
    $("#reg").click(function () {
        $.ajax({
            url: "/crm/register/",
            type: "POST",
            data: $("#regUser").serialize(),
            dataType: "JSON",
            traditional: true,
            success: function (obj) {
                if (obj.status) {
                    $("#userCue").text("注册成功！").css("color", "green");
                    $(".errors").text("");
                } else {
                    $("#username-error").text(obj.error.username ? obj.error.username : "");
                    $("#pwd-error").text(obj.error.pwd ? obj.error.pwd : "");
                    $("#pwd_again-error").text(obj.error.pwd_again ? obj.error.pwd_again : "");
                    $("#qq-error").text(obj.error.qq ? obj.error.qq : "");
                }
            }
        })
    })
});
