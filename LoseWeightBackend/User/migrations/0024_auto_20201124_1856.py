# Generated by Django 3.1.3 on 2020-11-24 10:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0023_auto_20201124_1854'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='nickname',
            field=models.CharField(default='轻记用户_L7UBIrcabV5w', max_length=64),
        ),
    ]
