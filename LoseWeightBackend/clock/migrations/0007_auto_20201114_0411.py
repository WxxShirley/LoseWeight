# Generated by Django 3.1.3 on 2020-11-14 04:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('clock', '0006_auto_20201114_0409'),
    ]

    operations = [
        migrations.AlterField(
            model_name='clockinitem',
            name='_id',
            field=models.CharField(default='1605327105Do5QhtGudWsZ', max_length=128, unique=True),
        ),
    ]