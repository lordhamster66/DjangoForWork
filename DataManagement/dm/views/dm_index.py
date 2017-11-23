from django.shortcuts import render
from dm.utils import get_info_list, get_sql_content, login_decorator


# Create your views here.
@login_decorator
def index(request):
    """dm首页"""
    home_dict = {
        "zhu_r": None,
        "sm_r": None,
        "tz_r": None,
        "amount": None,
        "g_amount": None,
        "un_r_auto_x_amount": None,
        "r_auto_amount": None,
        "un_r_auto_recover_account_list": [],
    }
    tz_info = get_info_list("rz", get_sql_content(12))[0]
    home_dict["zhu_r"] = get_info_list("rz", get_sql_content(24))[0].get("zhu_r")
    home_dict["sm_r"] = get_info_list("rz", get_sql_content(11))[0].get("sm_r")
    home_dict["tz_r"] = tz_info.get("tz_r")
    home_dict["amount"] = tz_info.get("amount")
    home_dict["g_amount"] = get_info_list("rz", get_sql_content(21))[0].get("g_amount") or 0
    home_dict["un_r_auto_x_amount"] = get_info_list("rz", get_sql_content(20))[0].get("un_r_auto_x_amount") or 0
    home_dict["r_auto_amount"] = get_info_list("rz", get_sql_content(19))[0].get("r_auto_amount") or 0
    home_dict["un_r_auto_recover_account_list"].append(
        float(get_info_list("rz", get_sql_content(22).format(date="DATE_SUB(CURDATE(),INTERVAL 1 day)"))[0].get(
            "un_r_auto_recover_account") or 0)
    )
    home_dict["un_r_auto_recover_account_list"].append(
        float(get_info_list("rz", get_sql_content(22).format(date="CURDATE()"))[0].get(
            "un_r_auto_recover_account") or 0)
    )
    home_dict["un_r_auto_recover_account_list"].append(
        float(get_info_list("rz", get_sql_content(22).format(date="DATE_ADD(CURDATE(),INTERVAL 1 day)"))[0].get(
            "un_r_auto_recover_account") or 0)
    )
    return render(request, "dm_index.html", {
        "home_dict": home_dict
    })
