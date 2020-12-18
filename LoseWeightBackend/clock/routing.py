from django.urls import path
from clock.consumers import MessageConsumer

websocket_urlpatterns = [
    path('ws/message/<str:user_mobile>/', MessageConsumer.as_asgi())
]
