# Generated by Django 3.1.3 on 2020-11-14 03:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0018_auto_20201113_1412'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_Ueckw9O2jpht', max_length=64),
        ),
    ]