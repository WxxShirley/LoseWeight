from django.urls import path
from Meal.views import *

urlpatterns = [
    path('show', show),
    path('upload', upload),
    path('recent', recent)
]