from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
import json


class MessageConsumer(WebsocketConsumer):
    def connect(self):
        self.room_group_name = self.scope["url_route"]["kwargs"]["user_mobile"]
        print(self.room_group_name)
        # 加入组
        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name,
            self.channel_name
        )
        self.accept()

    def disconnect(self):
        async_to_sync(self.channel_layer.group_discard)(
            self.room_group_name,
            self.channel_name
        )

    def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]
        print("receive:"+message)

    def finish_message(self, event):
        message = event['message']
        self.send(text_data=message)