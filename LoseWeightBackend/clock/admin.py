from django.contrib import admin
from .models import ClockInItem, ClockRecord, WeekRecord


# Register your models here.

class ClockInItemAdmin(admin.ModelAdmin):
    date_hierarchy = 'cTime'
    list_display = ['user', 'title', 'time_span', 'freq', 'status', 'cTime']
    list_filter = ['cTime', 'frequency', 'user', 'status']
    search_fields = ['title']


admin.site.register(ClockInItem, ClockInItemAdmin)


class RecordAdmin(admin.ModelAdmin):
    date_hierarchy = 'timestamp'
    list_display = ['user', 'bind_item', 'timestamp', 'detail']


admin.site.register(ClockRecord, RecordAdmin)


class WeekRecordAdmin(admin.ModelAdmin):
    date_hierarchy = 'timestamp'
    list_display = ['user', 'bind_item', 'week_num']


admin.site.register(WeekRecord, WeekRecordAdmin)
