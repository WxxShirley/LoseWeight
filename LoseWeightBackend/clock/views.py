import json
from datetime import datetime as dt
import time as t
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from .models import ClockInItem, ClockRecord
from User.models import User
from utils import mySerializer, random_str, now, day_now, login_required, get_current_week, get_year_start, \
    get_year_end, get_current_month, get_week_num
from .tasks import *


# Create your views here.
@login_required()
def create(request):
    """
    用户创建新的打卡
    :param request: 客户端请求
    :return: {'status':状态, 'type':错误/成功类型}
    """
    mobile = request.GET["mobile"]
    title = request.GET["title"]
    start_date = request.GET["startDate"]
    end_date = request.GET["endDate"]
    color = request.GET["color"]
    icon_theme = request.GET["icon"]
    freq = request.GET["freq"]

    # 先查用户是否有重名的
    user = User.objects.get(mobile=mobile)
    sets = ClockInItem.objects.filter(user=user, title=title)
    if sets:
        return HttpResponse(json.dumps({'status': 'error', 'type': 'duplicate'}))

    # 进行用户已经设定的长度判断
    sets = ClockInItem.objects.filter(user=user, status=True)
    if sets.count() >= 4:
        return HttpResponse(json.dumps({'status': 'error', 'type': 'over length'}))

    try:
        # 执行逻辑
        new_item = ClockInItem(user=user, title=title, start_date=start_date, end_date=end_date, frequency=freq,
                               icon_theme=icon_theme, color_theme=color, cTime=now(),
                               _id=str(int(t.time())) + random_str(12))
        new_item.save()
        return HttpResponse(json.dumps({'status': 'ok', 'type': new_item.id}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


@login_required()
def load(request):
    """
    加载用户待打卡内容
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    user = User.objects.get(mobile=mobile)
    print(day_now())
    sets = ClockInItem.objects.filter(user=user, status=True, end_date__gte=day_now(), start_date__lte=day_now())

    # 对数据打tag -> 今日是否已打卡
    res_list = []
    for item in sets:
        res_list.append({
            'id': item.id,
            'title': item.title,
            'startDate': str(item.start_date),
            'endDate': str(item.end_date),
            'freq': item.frequency,
            'icon': item.icon_theme,
            'color': item.color_theme,
            'cTime': str(item.cTime),
            # 今日是否已经打卡
            'hasTodayTag': ClockRecord.objects.filter(user=user, bind_item=item, timestamp=day_now()).count(),
            # 是否完成该任务本周的打卡计划
            'hasWeekTaskFinish': check_succ(mobile, item.title)
        })
    print(res_list)
    return HttpResponse(json.dumps(res_list), content_type='application/json')


@login_required()
def record(request):
    """
    用户完成一项打卡
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    user = User.objects.get(mobile=mobile)
    detail = request.GET["detail"]
    clock_item = ClockInItem.objects.filter(title=request.GET['title'], user=user)
    # 检查是否存在或者过期
    if not clock_item.count():
        return HttpResponse(json.dumps({'status': 'error', 'type': 'not exist'}))
    else:
        clock_item = clock_item[0]
        if not clock_item.status:
            return HttpResponse(json.dumps({'status': 'error', 'type': 'expired'}))
        # 检查是否同一天多次打卡
        if ClockRecord.objects.filter(user=user, bind_item=clock_item, timestamp=day_now()).count():
            return HttpResponse(json.dumps({'status': 'error', 'type': 'duplicate '}))

    try:
        new_record = ClockRecord(user=user, bind_item=clock_item, timestamp=day_now(), detail=detail)
        new_record.save()
        check_succ(mobile, request.GET['title'], 1)
        return HttpResponse(json.dumps({'status': 'ok', 'type': 'create success'}))
    except Exception as e:
        return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))


def start_end_records(mobile, start_day, end_day):
    """
    功能函数，查询任意两天间的打卡记录.MonthView和WeekView函数中被调用
    :return:
    """
    result_list = []

    user = User.objects.get(mobile=mobile)
    records = ClockRecord.objects.filter(user=user, timestamp__lte=end_day, timestamp__gte=start_day)

    for rec in records:
        result_list.append({
            "date": str(rec.timestamp),
            "title": rec.bind_item.title,
            "icon_theme": rec.bind_item.icon_theme,
            "color_theme": rec.bind_item.color_theme,
            "detail": rec.detail,
        })
    return result_list


@login_required()
def week_view(request):
    """
    周视图
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]

    start_day, end_day = get_current_week()
    result_list = start_end_records(mobile, start_day, end_day)

    return HttpResponse(json.dumps(result_list))


@login_required()
def month_view(request):
    """
    统计月视图，格式与周视图一致
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]

    start_day, end_day = get_current_month()
    print(start_day, end_day)
    result_list = start_end_records(mobile, start_day, end_day)
    return HttpResponse(json.dumps(result_list))


@login_required()
def year_view(request):
    """
    统计该用户年度的各个打卡记录
    :param request:
    :return:
    """
    year = dt.now().year
    start, end = str(year) + "-01-01", str(year) + "-12-31"

    user = User.objects.get(mobile=request.GET["mobile"])
    records = ClockRecord.objects.filter(user=user, timestamp__lte=end, timestamp__gte=start)

    # 返回的数据格式
    # {
    #   "跑步": [ "2020-11-07", "2020-09-30", ],
    #   ...
    # }
    mps, title2color = {}, {}

    for rec in records:
        if rec.bind_item.title not in mps.keys():
            mps[rec.bind_item.title] = str(rec.timestamp)
            title2color[rec.bind_item.title] = rec.bind_item.color_theme
        else:
            mps[rec.bind_item.title] += "\r\n" + str(rec.timestamp)
    res = []
    for (key, val) in mps.items():
        res.append({"title": key, "times": val, "color": title2color[key]})

    return HttpResponse(json.dumps(res), content_type="application/json")


def valid_check(mobile, title):
    user = User.objects.get(mobile=mobile)
    clock = ClockInItem.objects.filter(user=user, title=title)
    if clock.count() == 0 or clock.count() > 1:
        return {'error': 'length'}
    clock = clock[0]
    if not clock.status:
        return {'error': 'status'}
    return {'obj': clock}



@login_required()
def set_color(request):
    """
    修改打卡的主题色
    :param request:
    :return:
    """
    res = valid_check(request.GET["mobile"], request.GET["title"])
    if res and 'error' in res.keys():
        return HttpResponse(json.dumps({'status': 'error', 'type': res["error"]}))
    user = User.objects.get(mobile=request.GET["mobile"])
    try:
        ClockInItem.objects.filter(user=user, title=request.GET["title"]).update(color_theme=request.GET["color"])
        return HttpResponse(json.dumps({'status': 'ok', 'type': 'update success'}))
    except Exception as e:
        return HttpResponse(json.dumps({"status": 'error', 'type': str(e)}))


@login_required()
def set_end_date(request):
    """
    修改打卡结束日期
    :param request:
    :return:
    """
    res = valid_check(request.GET["mobile"], request.GET["title"])
    if res and 'error' in res.keys():
        return HttpResponse(json.dumps({'status': 'error', 'type': res["error"]}))
    user = User.objects.get(mobile=request.GET["mobile"])
    try:
        ClockInItem.objects.filter(user=user, title=request.GET["title"]).update(end_date=request.GET["end_date"])
        return HttpResponse(json.dumps({'status': 'ok', 'type': 'update success'}))
    except Exception as e:
        return HttpResponse(json.dumps({"status": 'error', 'type': str(e)}))


@login_required()
def delete(request):
    """
    删除打卡
    :param request:
    :return:
    """
    user = User.objects.get(mobile=request.GET["mobile"])
    res = valid_check(request.GET["mobile"], request.GET["title"])
    if res and 'error' in res.keys():
        return HttpResponse(json.dumps({'status': 'error', 'type': res["error"]}))

    user = User.objects.get(mobile=request.GET["mobile"])
    try:
        ClockInItem.objects.filter(user=user, title=request.GET["title"]).delete()
        return HttpResponse(json.dumps({'status': 'ok', 'type': 'delete succ'}))
    except Exception as e:
        return HttpResponse(json.dumps({"status": 'error', 'type': str(e)}))


@login_required()
def analysis(request):
    """
    对打卡结果实时统计
    :param request:
    :return:
    """
    user = User.objects.get(mobile=request.GET["mobile"])
    task = ClockInItem.objects.filter(user=user, title=request.GET["title"])[0]

    # 共打卡多少次
    nums = ClockRecord.objects.filter(user=user, bind_item=task).count()

    # 到现在已经执行了几周
    weeks = get_week_num(str(task.start_date), str(dt.now())[:10])+1
    # 有几周是完成任务的
    finish_nums = WeekRecord.objects.filter(user=user, bind_item=task).count()

    print(nums, weeks, finish_nums)
    res = str(nums)+"\r\n"+str(weeks)+"\r\n"+str(finish_nums)
    return HttpResponse(res)


@login_required()
def achieve(request):
    """
    我的成就
    :param request:
    :return:
    """
    user = User.objects.get(mobile=request.GET["mobile"])
    records = WeekRecord.objects.filter(user=user).order_by('-timestamp')
    res_list = []
    for rec in records:
        res_list.append(
            {
                "task_title": rec.bind_item.title,
                "task_icon": rec.bind_item.icon_theme,
                "task_color": rec.bind_item.color_theme,
                "timestamp": rec.timestamp,
                "week_num": str(rec.week_num)
            }
        )
    return JsonResponse(res_list, safe=False)