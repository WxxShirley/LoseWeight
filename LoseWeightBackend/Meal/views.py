import base64
import json
import os

from django.http import HttpResponse
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

from Meal.models import UserMeal
from User.models import User
import datetime
from utils import *


# Create your views here.
@csrf_exempt
def upload(request):
    """
    上传一餐图片
    :param request:
    :return:
    """
    mobile = request.POST["mobile"]
    file_name = request.POST["fileName"]
    image_content = request.POST["image"]
    index = request.POST["index"]

    user = User.objects.get(mobile=mobile)
    folder = "./static/meal/" + str(mobile) + "/" + day_now()
    print(folder)
    if not os.path.exists(folder):
        os.makedirs(folder)
    path = "/" + index + '.' + file_name.split(".")[-1]
    print(folder + path)

    with open(folder + path, 'wb+') as f:
        f.write(base64.b64decode(image_content))

    try:
        if index == "0":
            entry = UserMeal(user=user, day=day_now(), breakfast=folder + path,)
            entry.save()
        elif index == "1":
            UserMeal.objects.filter(user=user, day=day_now()).update(lunch=folder + path)
        elif index == "2":
            UserMeal.objects.filter(user=user, day=day_now()).update(dinner=folder + path)
        return HttpResponse(json.dumps({'status': 'ok', 'type': folder + path}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


def show(request):
    """
    加载一餐的图片
    :param request:
    :return:
    """
    path = request.GET["path"]
    print("request:" + path)
    with open(path, 'rb') as f:
        profile_data = f.read()

    return HttpResponse(profile_data, content_type='image/jpg')


@login_required()
def recent(request):
    """
    最近十天饮食图片
    :param request:
    :return:
    """
    today = datetime.now()
    day_begin = today - timedelta(days=10)

    user = User.objects.get(mobile=request.GET["mobile"])
    meals = UserMeal.objects.filter(user=user, day__gt=day_begin)
    res_list = []

    day_list = []
    for meal in meals:
        day_list.append(meal.day.strftime("%Y-%m-%d"))

    default = "./static/meal/non.png"

    while today != day_begin:
        today_str = today.strftime("%Y-%m-%d")
        if today_str not in day_list:
            res_list.append({
                "day": today_str,
                "breakfast": default,
                "lunch": default,
                "dinner": default,
            })
        today -= timedelta(days=1)

    for meal in meals:
        res_list.append(
            {
                "day": meal.day.strftime("%Y-%m-%d"),
                "breakfast": meal.breakfast,
                "lunch": meal.lunch,
                "dinner": meal.dinner,
            }
        )

    res_list.sort(key=lambda meal_: meal_["day"], reverse=True)
    return HttpResponse(json.dumps(res_list))
