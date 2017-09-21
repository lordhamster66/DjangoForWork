from django.shortcuts import render
from django.shortcuts import HttpResponse
from io import BytesIO
from utils.check_code import create_validate_code
from backend.forms import RegisterForm


# Create your views here.
def check_code(request):
    """
    验证码
    :param request:
    :return:
    """
    # stream = BytesIO()
    # img, code = create_validate_code()
    # img.save(stream, 'PNG')
    # request.session['CheckCode'] = code
    # return HttpResponse(stream.getvalue())

    # data = open('static/imgs/avatar/20130809170025.png','rb').read()
    # return HttpResponse(data)

    # 1. 创建一张图片 pip3 install Pillow
    # 2. 在图片中写入随机字符串
    # obj = object()
    # 3. 将图片写入到制定文件
    # 4. 打开制定目录文件，读取内容
    # 5. HttpResponse(data)

    stream = BytesIO()
    img, code = create_validate_code()
    img.save(stream, 'PNG')
    request.session['CheckCode'] = code
    return HttpResponse(stream.getvalue())


def login(request):
    pass


def register(request):
    """后台注册页面"""
    if request.method == "GET":
        register_obj = RegisterForm()
        return render(request, "register.html", {"register_obj": register_obj})
    elif request.method == "POST":
        register_obj = RegisterForm(request.POST)
        if register_obj.is_valid():
            pass
        else:
            return render(request, "register.html", {"register_obj": register_obj})
