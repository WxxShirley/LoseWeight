from django.urls import path
from Dynamic.views import *

urlpatterns = [
    path('publish', publish),
    path('showpic/<int:name>', showpic),
    path('load/<int:type_>', load),
    path('delete', delete),
    path('collect', collect),
    path('remove', remove),
    path('get_collection', get_collection),
    path('one_collection', one_collection)
]