#/bin/bash

RESULT=$(python -c 'print "test"')
RESULT=$?

if [[ $RESULT -ne 0 ]]
then
  echo "Please install python !";
  echo "https://www.python.org/downloads/ "
 
fi

RESULT=$(python -c "import django")
RESULT=$?

if [[ $RESULT -ne 0 ]]
then
  echo "To create Django project , you need to install Django !";
  echo "Trying to install Django with pip command .. "
  echo 'pip install Django==1.8.3'
  pip install Django==1.8.3
fi

echo "Enter your Django project name (e.g. myblog,webshop,website) ?"
read input_variable


echo "Creating Django project: $input_variable"
django-admin startproject $input_variable
RESULT=$?
DJANGO_PROJECT=$(pwd)/$input_variable

if [[ $RESULT -ne 0 ]]
then
  echo "Something goes wrong while trying to create django project  !";
  echo "Failed to run command "
  echo 'django-admin startproject $input_variable'
  echo "you can contact support team on djangotutsme.com to solve this problem!"  
else
	echo "Created django project:"

    echo $DJANGO_PROJECT

    python $DJANGO_PROJECT/manage.py startapp myapp
    DJANGO_APP=$DJANGO_PROJECT/myapp
    
    if [ ! -d "$DJANGO_APP" ]; then
      mv $(pwd)/myapp $DJANGO_PROJECT
      echo "Moved myapp"
    fi
	VIEWS=${DJANGO_PROJECT}/myapp/views.py
	MODELS=${DJANGO_PROJECT}/myapp/models.py
	ADMIN=${DJANGO_PROJECT}/myapp/admin.py
    URLS=${DJANGO_PROJECT}/$input_variable/urls.py
	SETTINGS=${DJANGO_PROJECT}/$input_variable/settings.py
    TEMPLATES=${DJANGO_PROJECT}/$input_variable/templates
    mkdir -p $TEMPLATES
    BASE=$TEMPLATES/base.html
    PAGE=$TEMPLATES/page.html
	
	echo "Creating : "
	echo $VIEWS
	echo $MODELS
	echo $ADMIN
	echo $URLS
	echo $SETTINGS
	echo "
from django.conf.urls import *  
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.contrib import admin
from django.conf import settings
from myapp.views import * 

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)), 
    url(r'^$', home), 
    url('^(?P<page_slug>.*)/$', article),
    url('^notfound/$', home),
    url(r'^sitemap\.xml$',generate_sitemap),
)


# This is only needed when using runserver.
if settings.DEBUG:
    urlpatterns = patterns('',
        url(r'^media/(?P<path>.*)$', 'django.views.static.serve', 
            {'document_root': settings.MEDIA_ROOT, 'show_indexes': True}),
        ) + staticfiles_urlpatterns() + urlpatterns  # NOQA
#If you have any question about Django visit www.djangotutsme.com">$URLS

echo '
from django.shortcuts import render
from django.shortcuts import render_to_response,RequestContext,render
import json
from .models import *
from django.http import HttpResponseRedirect
import re
import time

def home(request):

    
    meta_title="Home"
    meta_descr="my description"
    header_title="My Django Website"
    title="My Article"
    content="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras at metus ut elit ultricies interdum. Donec vel risus mauris. Quisque facilisis sit amet libero vel fermentum. Sed sit amet arcu a neque placerat lobortis quis at dui. Suspendisse nec arcu varius, interdum mi ac, viverra tellus. Aenean placerat lacinia diam, dictum mollis augue accumsan in. Aenean vel fringilla mauris. Phasellus non lorem sed augue pulvinar aliquam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam feugiat quam nisi, id viverra libero auctor at. Fusce sed quam cursus, euismod massa id, dapibus velit. Curabitur nunc ex, semper a mattis vel, accumsan et nulla."
   
    return render_to_response("page.html", 
            { 
            "title":title,
            "content":content,
            "meta_title":meta_title,
            "meta_descr":meta_descr,
            "header_title":header_title,
           
            }  
            ,context_instance=RequestContext(request))


def article(request,page_slug=""):

    header_title="Article 2"
    title="My title 2"
    meta_descr="Article description "
    content="lorem ipsum test info"
    header_title="My title 2"
    slug="/"+page_slug

  
    return render_to_response("page.html", 
            { 
            
            "meta_title":title,
            "meta_descr":meta_descr,
            "title":title,
            "content":content,
            "slug":slug,
            "header_title":header_title,
            }  
            ,context_instance=RequestContext(request))


def generate_sitemap(request):
    sitemap_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?><urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
    sitemap_data+="<url><loc>http://www.djangotutsme.com/</loc><lastmod>2014-10-10</lastmod><changefreq>monthly</changefreq><priority>1.0</priority></url>"
    pages=Pages.objects.filter(active=True)
    for data in pages:
        sitemap_data+="<url><loc>http://www.djangotutsme.com"+data.slug+"</loc><lastmod>"+str(data.date).split()[0]+"</lastmod><changefreq>monthly</changefreq><priority>0.5</priority></url>"

    sitemap_data+="</urlset>"  
    return HttpResponse(sitemap_data,content_type="application/xhtml+xml")
'>$VIEWS

echo '
{% load staticfiles %}
<!DOCTYPE html>
<html>
<head>
<title>{{meta_title}}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
<style>

.myheader{
min-height: 50px;
max-height: 130px;
height:auto;
width: 100%;
margin:0px auto;
/*background-image: url("/static/bg.jpg"); */ /* here you can add your background image*/
}
.myfooter{
padding-top: 17px;
height: 4em;
background-color: #f5f5f5;
width: 100%;
clear: both;
}

</style>
</head>
<body >
<div class="container">
<div class="myheader">
<div id="three-d"><center> <h1> {{header_title}}</h1></center></div>
</div>
<div class="row">
<div class="col-md-3">
<div class="list-group">

<a class="list-group-item" href="/article-2"><i class="fa fa-file-text-o fa-fw"></i>&nbsp; Article 2</a>

</div>
</div>
<div class="col-lg-9 ">
{% block content %}
{% endblock content %}
</div>
<div class="myfooter">
<div style="float:right;font-family: "Whitney 4r",Helvetica,Arial,sans-serif;
"><i>©2015 All Rights Reserved. • <a href ="http://djangotutsme.com/">djangotutsme.com</a> &nbsp &nbsp</i></div>
</div>
</div>
</div>
</body>
</html>
'>$BASE

echo '
{% extends "base.html" %}
{% block content %}
<h2> {{title}}</h2>
{{content|safe}}
{% endblock content %}
'>$PAGE

echo '
from django.db import models
from django.utils.text import slugify
from django.db.models import Q
#python manage.py makemigrations myapp
#python manage.py sqlmigrate myapp 
#python manage.py shell
########## FIELD TYPES #####################################################
# charfield -  name = models.CharField(max_length=256,null=True,blank=True) 
# boolean - active=models.BooleanField(default=False)
# integer - number = models.IntegerField() 
# textfield - comment = models.TextField(null=True,default=None,blank=True) 
# datetime - modified  = models.DateTimeField()
# datetime - date = models.DateTimeField(auto_now_add=True)
# imagefield - image = models.ImageField(upload_to = "media/", default = "media/no-img.jpg") #pip install Pillow
# manytomany - category = models.ManyToManyField(Category) 
# foreignkey -  user = models.ForeignKey(Users)
# choices -SHIRT_SIZES = (("S", "Small"),("M", "Medium"), ("L", "Large"),)
#         - shirt_size = models.CharField(max_length=1, choices=SHIRT_SIZES)
############################################################################

######### QUERYS ###########################################################
# slideshows = SLideshow.objects.filter()
#user.objects.get(email=email)
#Category.objects.filter(tree__startswith="parent",disable=False)
#Category.objects.filter(Q(tree__contains=children) & ~Q(tree__contains="-") & Q(disable=False))
#Invoices.objects.filter().order_by("-id")
#Subcat.objects.get(variants__name=subcategory)
#Poi.objects.filter(name__icontains=search_input)
#Poi.objects.filter(variants__name__icontains=search_input)

############################################################################


#class Settings(models.Model):

    #title = models.CharField(max_length=256) 
    #value = models.TextField(null=True,default=None,blank=True)
  
    

    #def __unicode__(self):
        #return self.title

    #class Meta:
        #verbose_name_plural="Settings"


#class Pages(models.Model):

    #title = models.CharField(max_length=256,null=True) 
    #short_descr = models.CharField(max_length=256,null=True,blank=True) 
    #content=models.TextField(null=True,default="")
    #slug = models.CharField(max_length=256,null=True,default="",blank=True) 
    #active = models.BooleanField(default=True)
    #date = models.DateTimeField(auto_now_add=True)
  
    #def slug_link(self):
        #return "<a target=\"_blank\" href=\"%s\">%s</a>" % (self.slug,self.slug)
    #slug_link.allow_tags = True


    #def __unicode__(self):
        #return self.title 

    
    #def save(self):
    
        #if Pages.objects.filter(title=self.title).count()>0:
            #title=self.title+str(self.id)
        #else:
            #title=self.title
        
        #self.slug ="/%s" % (slugify(self.title))
        
        #super(Pages, self).save()


    #class Meta:
        #verbose_name_plural="Pages"
'>$MODELS

echo '
from django.contrib import admin
from .models import *
from django import forms


#class PagesAdmin(admin.ModelAdmin):
    
    #search_fields = ("title",)
    #list_display = ("title","id","slug_link")

#admin.site.register(Pages,PagesAdmin)



#class SetingsAdmin(admin.ModelAdmin):

    #search_fields = ("title",)
    #list_display = ("title",)        
    #actions = None



#admin.site.register(Settings,SetingsAdmin)

'>$ADMIN

echo "

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))



# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '2k1so@-tg7o38%i7d#qhn%@k(b)y(#6f0c=xkrl#tqs##&5$c!'

# SECURITY WARNING: don't run with dxebug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True



#ALLOWED_HOSTS = ['djangotutsme.com','www.djangotutsme.com']#add your domain 


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
     #'myapp',
   
)

   
MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = '${input_variable}.urls'

WSGI_APPLICATION = '${input_variable}.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases



TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
#   
)
# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en'

TIME_ZONE = 'America/Chicago'


USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_URL = '/static/'


STATIC_ROOT = os.path.join(BASE_DIR,'static')
if not os.path.exists(STATIC_ROOT):
    os.makedirs(STATIC_ROOT)


STATIC_DIR=os.path.join(BASE_DIR, '$input_variable', 'static')

STATICFILES_DIRS = (
    STATIC_DIR,
)

if not os.path.exists(STATIC_DIR):
    os.makedirs(STATIC_DIR)


TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.debug',
    'django.core.context_processors.i18n',
    'django.core.context_processors.media',
    'django.core.context_processors.static',
    'django.contrib.auth.context_processors.auth',
    'django.contrib.messages.context_processors.messages',
)

TEMPLATE_DIRS = (os.path.join(BASE_DIR,'$input_variable','templates'),)


MEDIA_URL = '/media/'

MEDIA_ROOT = os.path.join(BASE_DIR,'media')



DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME':os.path.join(BASE_DIR,'data.sqlite3') ,
    }
}

DEFAULT_FROM_EMAIL='email@xour_address.com'
EMAIL_HOST='YOUR SMTP'
EMAIL_PORT=25
EMAIL_HOST_USER='WEBMAIL USERNAME'
EMAIL_HOST_PASSWORD='WEBMAIL PASSWORD'

">$SETTINGS

python $DJANGO_PROJECT/manage.py syncdb
python $DJANGO_PROJECT/manage.py migrate

python $DJANGO_PROJECT/manage.py runserver 5000 &

echo "You can uncomment database model from models.py, admin.py and use below commands to create database model"
echo "FIRST UNCOMMENT #myapp FROM settings.py"
echo 'python $DJANGO_PROJECT/manage.py makemigrations myapp'
echo 'python $DJANGO_PROJECT/manage.py migrate'
echo ""
echo "Django website: http://127.0.0.1:5000/"
echo "Django admin: http://127.0.0.1:5000/admin"
echo "Static files: $(pwd)/$input_variable/$input_variable/static"
echo "To get static files python manage.py collectstatic"
echo "Example for static files in html <img src='/static/image.jpg'>"

fi


