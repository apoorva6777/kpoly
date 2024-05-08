from django.http import JsonResponse


# Create your views here.
def ping(request):
    return JsonResponse({
        'status': 200,
        'message': 'Ping Successful!!'
    })
