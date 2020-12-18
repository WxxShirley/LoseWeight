import base64
import json
import os

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from .models import *
from utils import *


# Create your views here.
@csrf_exempt
def publish(request):
    """
    用户发布新的动态
    :param request:
    :return:
    """
    mobile = request.POST["mobile"]
    user = User.objects.get(mobile=mobile)
    txt_content = request.POST["txt_content"]
    image_len = request.POST["image_len"]
    type_ = request.POST["type"]

    len_ = eval(image_len)
    print(mobile, txt_content, len_, type_)
    paths = ""
    for i in range(len_):
        try:
            content_key = "image_content" + str(i)
            image_content = request.POST[content_key]
            """
            folder = "./static/dynamic/" + str(mobile) + "/" + day_now()+"/"
            print(folder)
            if not os.path.exists(folder):
                os.makedirs(folder)
            name_key = "image_name" + str(i)
            name = request.POST[name_key]
            with open(folder+name, 'wb+') as f:
                f.write(base64.b64decode(image_content))
            """
            folder = "./static/dynamic/"
            name_key = "image_name" + str(i)
            # name = request.POST[name_key]
            img_title = str(mobile)+str(random.randint(10000, 99999))
            img_name = img_title + ".jpg"
            paths += img_title
            with open(folder + img_name, 'wb+') as f:
                f.write(base64.b64decode(image_content))
            paths += ","
        except Exception as e:
            print(e)
            return HttpResponse(json.dumps({'status': 'error', 'type': str(e)}))

    print(paths)
    dynamic = UserDynamic(user=user, timestamp=now(), id=mobile + str(datetime.now()),
                          txt_content=txt_content, image_list=paths, type=type_
                          )
    dynamic.save()
    return HttpResponse(json.dumps({'status': 'ok', 'type': 'succ'}))


def showpic(request, name):
    print(name)
    with open("./static/dynamic/"+str(name)+".jpg", 'rb') as f:
        profile_data = f.read()
        return HttpResponse(profile_data, content_type='image/jpg')


def load(request, type_):
    """
    加载动态， 根据type_决定是查看动态的时候加载 还是 加载自己的发布动态
    :param type_:
    :param request:
    :return:
    """
    def searize(query_set):
        res_list = []
        for query in query_set:
            res_list.append(
                {
                    "user_avatar": query.user.profile,
                    "user_nickname": query.user.nickname,
                    "user_mobile": query.user.mobile,
                    "id": query.id,
                    "timestamp": query.timestamp,
                    "txt_content": query.txt_content,
                    "image_list": query.image_list,
                    "type": query.type,
                }
            )
        return res_list

    if type_ == 1:
        start_pos = eval(request.GET["start"])
        end_pos = start_pos+3
        query_set = UserDynamic.objects.order_by('-timestamp')[start_pos:end_pos]
        print(query_set)
    elif type_ == 2:
        user = User.objects.get(mobile=request.GET["mobile"])
        query_set = UserDynamic.objects.filter(user=user).order_by('-timestamp')

    return JsonResponse(searize(query_set), safe=False)


@login_required()
def delete(request):
    """
    用户删除已经发布的动态
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    dynamic_id = request.GET["dynamic_id"]
    try:
        user = User.objects.get(mobile=mobile)
        UserDynamic.objects.filter(user=user, id=dynamic_id).delete()
        return JsonResponse({'status': 'ok', 'type': 'del succ'})
    except Exception as e:
        return JsonResponse({'status': 'error', 'type': str(e)})


@login_required()
def collect(request):
    """
    添加到收藏夹
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    collection_name = request.GET["collection_name"]
    # is_new = eval(request.GET["is_new"])
    bind_dynamic = request.GET["bind_dynamic"]

    user = User.objects.get(mobile=mobile)
    dynamic = UserDynamic.objects.get(id=bind_dynamic)

    is_exist = Collections.objects.filter(user=user, collection_name=collection_name)
    if not is_exist.count():
        id_ = mobile+"_"+random_str(16)
        new_collection = Collections(id=id_, user=user, collection_name=collection_name, create_time=now())
        new_collection.save()

    bind_collection = Collections.objects.filter(user=user, collection_name=collection_name)[0]
    image = dynamic.image_list.split(",")[0]
    try:
        new_record = UserCollectionRecord(user=user, bind_collection=bind_collection, bind_dynamic=dynamic,
                                          preview_img=image, add_time=now())
        new_record.save()
        return JsonResponse({'status': 'ok', 'type': 'add succ'})
    except Exception as e:
        return JsonResponse({'status': 'error', 'type': str(e)})


@login_required()
def remove(request):
    """
    从收藏夹移除
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    collection_id = request.GET["collection_id"]
    bind_dynamic = request.GET["bind_dynamic"]

    try:
        user = User.objects.get(mobile=mobile)
        dynamic = UserDynamic.objects.get(id=bind_dynamic)
        collection = Collections.objects.get(id=collection_id)
        UserCollectionRecord.objects.filter(user=user, bind_collection=collection, bind_dynamic=dynamic).delete()
        return JsonResponse({'status': 'ok', 'type': 'del succ'})
    except Exception as e:
        return JsonResponse({'status': 'error', 'type': str(e)})


@login_required()
def get_collection(request):
    """
    加载用户的收藏夹
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    user = User.objects.get(mobile=mobile)

    collections = Collections.objects.filter(user=user)
    res_list = []
    for collection in collections:
        records = UserCollectionRecord.objects.filter(user=user, bind_collection=collection)
        num = records.count()
        image = records[0].preview_img
        res_list.append(
            {
                "name": collection.collection_name,
                "id": collection.id,
                "num": str(num),
                "image": image,
                #"create_time": collection.create_time
            }
        )

    return JsonResponse(res_list, safe=False)


@login_required()
def one_collection(request):
    """
    加载某个收藏夹中的动态
    :param request:
    :return:
    """
    mobile = request.GET["mobile"]
    user = User.objects.get(mobile=mobile)

    collect_id = request.GET["collection_id"]
    collection = Collections.objects.get(id=collect_id)

    query_set = UserCollectionRecord.objects.filter(user=user, bind_collection=collection)
    res_list = []
    for query in query_set:
        res_list.append({
            "user_nickname": query.bind_dynamic.user.nickname,
            "user_avatar": query.bind_dynamic.user.profile,
            "user_mobile": query.bind_dynamic.user.mobile,
            "id": query.bind_dynamic.id,
            "timestamp": query.bind_dynamic.timestamp,
            "txt_content": query.bind_dynamic.txt_content,
            "image_list": query.bind_dynamic.image_list,
            "type": query.bind_dynamic.type,
        })
    return JsonResponse(res_list, safe=False)
