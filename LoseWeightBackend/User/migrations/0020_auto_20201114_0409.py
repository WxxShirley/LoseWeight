# Generated by Django 3.1.3 on 2020-11-14 04:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0019_auto_20201114_0330'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_pc30VaZJmK4C', max_length=64),
        ),
    ]