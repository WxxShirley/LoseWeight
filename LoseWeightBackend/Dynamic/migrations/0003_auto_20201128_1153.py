# Generated by Django 3.1.3 on 2020-11-28 03:53

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('User', '0032_auto_20201128_1153'),
        ('Dynamic', '0002_auto_20201127_1335'),
    ]

    operations = [
        migrations.CreateModel(
            name='Collections',
            fields=[
                ('id', models.CharField(max_length=128, primary_key=True, serialize=False)),
                ('collection_name', models.CharField(default='默认收藏夹', max_length=256)),
                ('create_time', models.DateTimeField()),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='User.user')),
            ],
            options={
                'verbose_name': '用户收藏夹',
                'verbose_name_plural': '用户收藏夹',
                'ordering': ['-create_time'],
                'unique_together': {('user', 'collection_name')},
            },
        ),
        migrations.AlterField(
            model_name='userdynamic',
            name='id',
            field=models.CharField(default='2020-11-28 11:53:02.029555', max_length=128, primary_key=True, serialize=False),
        ),
        migrations.CreateModel(
            name='UserCollectionRecord',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('preview_img', models.CharField(default='', max_length=512)),
                ('add_time', models.DateTimeField()),
                ('bind_collection', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Dynamic.collections')),
                ('bind_dynamic', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Dynamic.userdynamic')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='User.user')),
            ],
        ),
    ]