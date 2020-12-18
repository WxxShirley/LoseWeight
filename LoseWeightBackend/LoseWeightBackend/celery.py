from __future__ import absolute_import, unicode_literals
import os
from celery import Celery, platforms

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LoseWeightBackend.settings')

app = Celery('LoseWeightBackend', broker='redis://127.0.0.1:6379/4', backend='redis://127.0.0.1:6379/5')


app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()
