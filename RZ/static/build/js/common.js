/**
 * Created by Administrator on 2017/8/18.
 */
$(function () {
    $(".datepicker").datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: "yy-mm-dd"
    });
});
$(".subNav").click(function () {
    $(this).toggleClass("currentDd").siblings(".subNav").removeClass("currentDd");
    $(this).toggleClass("currentDt").siblings(".subNav").removeClass("currentDt");
    $(this).next(".navContent").slideToggle(300).siblings(".navContent").slideUp(500)
})