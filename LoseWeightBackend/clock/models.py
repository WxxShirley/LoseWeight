import time

from django.db import models
from django.utils import timezone
from datetime import datetime
from User.models import User


# Create your models here.
from utils import random_str


class ClockInItem(models.Model):
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    _id = models.CharField(max_length=128, unique=True, default=str(int(time.time()))+random_str(12))
    title = models.CharField(max_length=64, default="待打卡任务")
    start_date = models.DateField()
    end_date = models.DateField()
    frequency = models.PositiveIntegerField(default=1,)
    icon_theme = models.CharField(max_length=64, default='star')
    color_theme = models.CharField(max_length=64, default='0xffff')
    cTime = models.DateTimeField()

    # true - 正在进行, false - 已经结束
    status = models.BooleanField(default=True)

    class Meta:
        ordering = ['-cTime']
        verbose_name = '打卡'
        verbose_name_plural = '打卡'
        unique_together = ('user', 'title') # 对每个用户而言，每个打卡任务的title是唯一的

    def __str__(self):
        return self.title

    def time_span(self):
        return self.start_date.strftime("%Y-%m-%d") + '至' + self.end_date.strftime("%Y-%m-%d")

    def freq(self):
        return "每周" + str(self.frequency) + "次"


class ClockRecord(models.Model):
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    bind_item = models.ForeignKey(to="ClockInItem", to_field='_id', on_delete=models.CASCADE)
    timestamp = models.DateField()
    detail = models.CharField(max_length=256, default="打卡成功！")

    def __str__(self):
        return self.user.nickname

    class Meta:
        ordering = ['-timestamp']
        verbose_name = '打卡记录'
        verbose_name_plural = '打卡记录'
        unique_together = ('user', 'bind_item', 'timestamp')


class WeekRecord(models.Model):
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    bind_item = models.ForeignKey(to="ClockInItem", to_field='_id', on_delete=models.CASCADE)
    timestamp = models.DateField()
    week_num = models.IntegerField(default=int(time.strftime("%W")))

    def __str__(self):
        return self.user.nickname

    class Meta:
        ordering = ['-timestamp']
        verbose_name = '周完成记录'
        verbose_name_plural = '周完成记录'
        unique_together = ('user', 'bind_item', 'week_num')
