# Generated by Django 3.1.3 on 2020-11-27 05:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0030_auto_20201127_1328'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_gJIZSPiC13zu', max_length=64),
        ),
    ]
