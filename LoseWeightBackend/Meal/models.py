from django.db import models

# Create your models here.
from django.utils.html import format_html


class UserMeal(models.Model):
    user = models.ForeignKey(to="User.User", to_field='mobile', on_delete=models.CASCADE)
    day = models.DateField()
    breakfast = models.CharField(max_length=1024, null=True, default="./static/meal/non.png")
    lunch = models.CharField(max_length=1024, null=True, default="./static/meal/non.png")
    dinner = models.CharField(max_length=1024, null=True, default="./static/meal/non.png")

    def __str__(self):
        return self.user.nickname + str(self.day)

    class Meta:
        ordering = ['-day']
        verbose_name = '每日饮食记录'
        verbose_name_plural = '每日饮食记录'
        unique_together = ('user', 'day')

    def show_breakfast(self):
        if self.breakfast == "":
            img = "./static/meal/non.png"
        else:
            img = self.breakfast
        url = "http://127.0.0.1:8000/meal/show?path=" + img
        return format_html(
            '<img src="{}" width="50px" /> ', url
        )

    show_breakfast.short_description = "早餐"

    def show_lunch(self):
        if self.lunch == "":
            img = "./static/meal/non.png"
        else:
            img = self.lunch
        url = "http://127.0.0.1:8000/meal/show?path=" + img
        return format_html(
            '<img src="{}" width="50px" /> ', url
        )

    show_lunch.short_description = "午餐"

    def show_dinner(self):
        if self.dinner == "":
            img = "./static/meal/non.png"
        else:
            img = self.dinner
        url = "http://127.0.0.1:8000/meal/show?path=" + img
        return format_html(
            '<img src="{}" width="50px" /> ', url
        )

    show_dinner.short_description = "晚餐"
