# Generated by Django 3.1.3 on 2020-11-26 04:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0026_auto_20201125_1116'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_3nmw148u0Bxe', max_length=64),
        ),
    ]
