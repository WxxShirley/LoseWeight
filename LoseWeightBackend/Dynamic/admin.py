from django.contrib import admin

# Register your models here.
from Dynamic.models import *


class UserDynamicAdmin(admin.ModelAdmin):
    date_hierarchy = 'timestamp'
    list_display = ['user', 'txt_content', 'type', 'secondary_type', 'collections']


admin.site.register(UserDynamic, UserDynamicAdmin)


class CollectionAdmin(admin.ModelAdmin):
    date_hierarchy = 'create_time'
    list_display = ['user', 'collection_name', 'create_time']


admin.site.register(Collections, CollectionAdmin)


class UserCollectionRecordAdmin(admin.ModelAdmin):
    date_hierarchy = 'add_time'
    list_display = ['user', 'bind_collection', 'bind_dynamic', 'add_time']


admin.site.register(UserCollectionRecord, UserCollectionRecordAdmin)
