from django.contrib import admin
from dm import models

# Register your models here.
admin.site.register(models.UserProfile)
admin.site.register(models.Role)
admin.site.register(models.Menu)
admin.site.register(models.Department)
admin.site.register(models.SQLRecord)
admin.site.register(models.SQLContent)
admin.site.register(models.SQLTag)
