from django.urls import path
from User.views import *

urlpatterns = [
    path('login', login),
    path('register', register),
    path('load', load),

    path('change', change),
    path('profile', profile)
]
