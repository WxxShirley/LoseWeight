import time
from LoseWeightBackend.celery import app as celery_app
from utils import get_current_week, day_now
from .models import *
from User.models import *
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
import datetime


@celery_app.task
def check_succ(mobile, title, pos=0):
    """
    检查用户是否完成本周的打卡任务
    :return:
    """
    monday, sunday = get_current_week()

    user = User.objects.get(mobile=mobile)
    clock = ClockInItem.objects.filter(user=user, title=title)[0]
    nums = ClockRecord.objects.filter(user=user, bind_item=clock, timestamp__gte=monday, timestamp__lte=sunday).count()
    freq = clock.frequency
    print(nums, freq)
    if nums == freq:
        if pos == 1:
            # 发送异步socket消息
            print("in send socket message")
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                mobile, {"message": title, "type": 'finish_message'}
            )
            # 将完成消息插入到表WeekRecord中
            try:
                new_week_record = WeekRecord(user=user, bind_item=clock, timestamp=day_now())
                new_week_record.save()
            except Exception as e:
                print("insert week record error"+str(e))
        return 1
    elif nums > freq:
        return 1
    else:
        return 0
