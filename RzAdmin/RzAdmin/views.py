from django.shortcuts import render


# Create your views here.
def index(request):
    return render(request, "index.html")


def acc_login(request):
    return render(request, "login.html")
