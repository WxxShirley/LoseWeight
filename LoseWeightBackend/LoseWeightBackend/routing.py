from channels.routing import ProtocolTypeRouter, URLRouter
import clock.routing
from channels.auth import AuthMiddlewareStack
from channels.security.websocket import AllowedHostsOriginValidator


application = ProtocolTypeRouter({
    'websocket':
        AuthMiddlewareStack(
            URLRouter(clock.routing.websocket_urlpatterns)
    )
})

