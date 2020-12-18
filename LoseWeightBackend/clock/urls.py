from django.urls import path
from clock.views import *

urlpatterns = [
    path('create', create),
    path('load', load),
    path('record', record),

    path('week/view', week_view),
    path('month/view', month_view),
    path('year/view', year_view),

    path('set/color', set_color),
    path('set/end_date', set_end_date),

    path('delete', delete),
    path('analysis', analysis),

    path('achieve', achieve),
]