# Generated by Django 3.1.3 on 2020-11-26 04:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('clock', '0012_auto_20201125_1116'),
    ]

    operations = [
        migrations.AlterField(
            model_name='clockinitem',
            name='_id',
            field=models.CharField(default='1606366733SwzOYd4keDaN', max_length=128, unique=True),
        ),
    ]