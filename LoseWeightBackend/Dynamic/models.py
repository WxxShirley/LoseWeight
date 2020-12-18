from django.db import models
from datetime import *

# Create your models here.


class UserDynamic(models.Model):
    id = models.CharField(primary_key=True, max_length=128, default=str(datetime.now()))
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    txt_content = models.TextField(default="...")
    image_list = models.CharField(max_length=2048, default="", null=False)

    type_choices = (
        ('sport', '健身'),  # 跑步， 有氧， 无氧， hit
        ('food', '饮食'),  # 低卡美食， 健身三餐， 自制饮食
        ('experience', '经验')  # 对比, 历程， 日常
    )
    type = models.CharField(max_length=64, choices=type_choices, default="sport")

    secondary_types = (
        ('run', '跑步'),
        ('air', '有氧'),
        ('no_air', '无氧'),
        ('hit', 'HIT运动'),

        ('low_calorie', '低卡'),
        ('fit_meal', '健身三餐'),
        ('diy_meal', '自制美食'),

        ('contrast', '对比'),
        ('long_way', '历程'),
        ('daily', '日常'),
    )
    secondary_type = models.CharField(max_length=64, default="run", choices=secondary_types)
    collections = models.IntegerField(default=0)

    def __str__(self):
        return self.user.nickname

    class Meta:
        ordering = ['-timestamp']
        verbose_name = '用户动态'
        verbose_name_plural = '用户动态'


class Collections(models.Model):
    id = models.CharField(max_length=128, primary_key=True)
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    collection_name = models.CharField(max_length=256, default="默认收藏夹")
    create_time = models.DateTimeField()

    def __str__(self):
        return self.user.nickname + self.collection_name

    class Meta:
        ordering = ['-create_time']
        verbose_name = '用户收藏夹'
        verbose_name_plural = '用户收藏夹'
        unique_together = ('user', 'collection_name')


class UserCollectionRecord(models.Model):
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    bind_collection = models.ForeignKey(to="Collections", to_field='id', on_delete=models.CASCADE)
    preview_img = models.CharField(max_length=512, default="")
    bind_dynamic = models.ForeignKey(to="UserDynamic", to_field="id", on_delete=models.CASCADE)
    add_time = models.DateTimeField()

    class Meta:
        ordering = ['add_time']
        verbose_name = "用户收藏记录"
        verbose_name_plural = "用户收藏记录"
        unique_together = ('user', 'bind_collection', 'bind_dynamic')
