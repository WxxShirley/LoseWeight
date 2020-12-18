from django.contrib import admin

# Register your models here.
from Meal.models import UserMeal


class UserMealAdmin(admin.ModelAdmin):
    date_hierarchy = 'day'
    list_display = ['user', 'day', 'show_breakfast', 'show_lunch', 'show_dinner']


admin.site.register(UserMeal, UserMealAdmin)