import json

from django.http import HttpResponse
from utils import mySerializer, md5, day_now, login_required
from .models import User


# Create your views here.
def login(request):
    """
    用户登陆
    :param request:
    :return:
    """
    try:
        mobile = request.GET["mobile"]
        u = User.objects.get(mobile=mobile)
        print(md5(request.GET["pwd"]))
        if u.password == md5(request.GET["pwd"]):
            return HttpResponse(json.dumps({'status': 'ok', 'type': u.token}))
        else:
            return HttpResponse(json.dumps({'status': 'error', 'type': 'not match'}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


def register(request):
    """
    新用户注册
    :param request:
    :return:
    """
    try:
        mobile = request.GET["mobile"]
        pwd = request.GET["password"]
        nickname = request.GET["nickname"]

        user = User.objects.filter(mobile=mobile)
        if user.count():
            return HttpResponse(json.dumps({'status': 'error', 'type': 'duplicate'}))

        c_time = day_now()
        new_user = User(mobile=mobile, password=md5(pwd), nickname=nickname, cTime=c_time)
        new_user.save()
        return HttpResponse(json.dumps({'status': 'ok', 'type': new_user.token}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


@login_required()
def load(request):
    """
    加载用户的个人信息
    :param request:
    :return:
    """
    user = User.objects.get(mobile=request.GET["mobile"])
    result = {
        "mobile": user.mobile,
        "nickname": user.nickname,
        "profile": user.profile,
        "password": user.password,
        "cTime": str(user.cTime),
        "gender": user.gender
    }
    return HttpResponse(json.dumps(result))


@login_required()
def change(request):
    """
    修改用户的个人信息
    :param request:
    :return:
    """
    key = request.GET["key"]
    val = request.GET["val"]
    try:
        if key == 'nickname':
            User.objects.filter(mobile=request.GET["mobile"]).update(nickname=val)
        elif key == 'password':
            User.objects.filter(mobile=request.GET["mobile"]).update(password=md5(val))
        elif key == 'gender':
            User.objects.filter(mobile=request.GET["mobile"]).update(gender=val)
        return HttpResponse(json.dumps({'status': 'ok', 'type': 'update succ'}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


def profile(request):
    """
    加载用户头像
    :param request:
    :return:
    """
    path = request.GET["path"]
    with open(path, 'rb') as f:
        profile_data = f.read()
    suffix = path.split('.')[-1]
    return HttpResponse(profile_data, content_type='image/'+suffix)
