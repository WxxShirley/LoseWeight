from datetime import *

import jwt
from django.db import models
from django.utils import timezone
from django.utils.html import format_html
import random
import string

from LoseWeightBackend import settings


def user_directory_path(instance, filename):
    return 'user_{0}/{1}'.format(instance.mobile, filename)


def random_str(num):
    salt = ''.join(random.sample(string.ascii_letters + string.digits, num))
    return salt


class User(models.Model):
    mobile = models.BigIntegerField(primary_key=True)
    nickname = models.CharField(max_length=64, default="轻记用户_"+random_str(12))
    password = models.CharField(max_length=512, null=False, default="Lose weight")
    profile = models.CharField(max_length=512, null=False, default="./static/profile/default.png")
    cTime = models.DateField()

    genderType = models.TextChoices('male', 'female')
    gender = models.CharField(default='male', choices=genderType.choices, max_length=10)

    def __str__(self):
        return self.nickname

    @property
    def token(self):
        return self._generate_jwt_token()

    def _generate_jwt_token(self):
        token = jwt.encode({
            'exp': datetime.utcnow() + timedelta(days=14),
            'iat': datetime.utcnow(),
            'data': {
                'mobile': self.mobile,
                'nickname': self.nickname
            }
        }, settings.SECRET_KEY, algorithm='HS256')
        return token.decode('utf-8')

    def show_profile(self):
        url = "http://127.0.0.1:8000/user/profile?path="+self.profile
        return format_html(
            '<img src="{}" width="50px" /> ', url
        )
    show_profile.short_description = "用户头像"

    class Meta:
        ordering = ["-cTime"]
        verbose_name = "用户"
        verbose_name_plural = "用户"
