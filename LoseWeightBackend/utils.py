import jwt
from django.core import serializers
from django.core.serializers.json import DjangoJSONEncoder
from django.http import JsonResponse

from LoseWeightBackend import settings
from User.models import User
import random
import string
from datetime import *
import arrow
import hashlib


class LazyEncoder(DjangoJSONEncoder):
    def default(self, obj):
        if isinstance(obj, User):
            return str(obj)
        return super().default(obj)


def mySerializer(dataset):
    return serializers.serialize('json', queryset=dataset, cls=LazyEncoder)


def random_str(num):
    salt = ''.join(random.sample(string.ascii_letters + string.digits, num))
    return salt


def now():
    return datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def day_now():
    return datetime.now().strftime("%Y-%m-%d")


def login_required():
    def decorator(view_func):
        def _wrapped_view(request, *args, **kwargs):
            try:
                auth = request.META.get('HTTP_AUTHORIZATION').split(" ")
            except AttributeError:
                return JsonResponse({"status": 'error', "type": "No auth"})

            if auth[0] == 'token':
                try:
                    dict = jwt.decode(auth[1], settings.SECRET_KEY, algorithms=['HS256'])
                    mobile = dict.get('data').get('mobile')
                except jwt.ExpiredSignatureError:
                    return JsonResponse({"status": 'error', "type": "Token expired"})
                except jwt.InvalidTokenError:
                    return JsonResponse({"status": 'error', "type": "Invalid"})
                except Exception as e:
                    return JsonResponse({"status": 'error', "type": str(e)})

                try:
                    user = User.objects.get(mobile=mobile)
                except User.DoesNotExist:
                    return JsonResponse({"status": 'error', "type": "User not exist"})

                if str(mobile) != request.GET["mobile"]:
                    return JsonResponse({"status": 'error', "type": "Not match user"})
            else:
                return JsonResponse({"status": 'error', "type": "no token bad request"})

            return view_func(request, *args, **kwargs)
        return _wrapped_view
    return decorator


def get_current_week():
    start_day, end_day = date.today(), date.today()
    one_day = timedelta(days=1)
    while start_day.weekday() != 0:
        start_day -= one_day
    return start_day, end_day


def get_current_month():
    cur_date = datetime.now()
    # 当前年份、月份
    year = cur_date.year
    month = cur_date.month
    start_day = date(year, month, 1)
    if month == 12:
        end_day = date(year+1, 1, 1)-timedelta(days=1)
    else:
        end_day = date(year, month+1, 1)-timedelta(days=1)
    return start_day, end_day


def get_year_start():
    now_ = arrow.utcnow().to("local")
    return now_.floor("year")


def get_year_end():
    now_ = arrow.utcnow().to("local")
    return now_.ceil("year")


def get_week_num(start_day, end_day):
    week_start = datetime.strptime(start_day, '%Y-%m-%d')
    week_end = datetime.strptime(end_day, '%Y-%m-%d')
    return int(datetime.strftime(week_end, "%W")) - int(datetime.strftime(week_start, "%W"))


def md5(password):
    hl = hashlib.md5()
    hl.update(password.encode(encoding='utf-8'))
    return hl.hexdigest()
