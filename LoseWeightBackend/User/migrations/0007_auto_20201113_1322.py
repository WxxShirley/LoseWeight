# Generated by Django 3.1.3 on 2020-11-13 13:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0006_auto_20201113_1319'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_xS6YcmLFehtD', max_length=64),
        ),
    ]