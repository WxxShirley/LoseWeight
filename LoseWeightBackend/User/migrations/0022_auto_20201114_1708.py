# Generated by Django 3.1.3 on 2020-11-14 09:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0021_auto_20201114_0411'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_v3D0tjzmAowQ', max_length=64),
        ),
    ]