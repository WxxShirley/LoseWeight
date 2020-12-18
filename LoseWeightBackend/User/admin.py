from django.contrib import admin
from .models import User


# Register your models here.

class UserAdmin(admin.ModelAdmin):
    date_hierarchy = 'cTime'
    list_display = ['mobile', 'nickname', 'cTime', 'show_profile']
    list_filter = ['cTime', ]


admin.site.register(User, UserAdmin)
