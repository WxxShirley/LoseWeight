# Generated by Django 3.1.3 on 2020-11-13 14:12

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('clock', '0003_auto_20201113_1408'),
    ]

    operations = [
        migrations.AlterField(
            model_name='clockinitem',
            name='_id',
            field=models.CharField(default='1605276769vmL0YzxS9wT4', max_length=128, unique=True),
        ),
        migrations.AlterField(
            model_name='clockrecord',
            name='timestamp',
            field=models.DateField(),
        ),
    ]
