# Generated by Django 3.1.3 on 2020-11-27 05:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('clock', '0014_auto_20201127_0002'),
    ]

    operations = [
        migrations.AlterField(
            model_name='clockinitem',
            name='_id',
            field=models.CharField(default='1606454818kbfta3nGj5Zz', max_length=128, unique=True),
        ),
    ]