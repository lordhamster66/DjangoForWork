from django.contrib import admin
from dm import models


# Register your models here.
class SQLRecordAdmin(admin.ModelAdmin):
    """SQL记录Admin"""
    list_display = ("user", "sql_name", "department", "date")
    search_fields = ("sql_name",)


admin.site.register(models.UserProfile)
admin.site.register(models.Role)
admin.site.register(models.Menu)
admin.site.register(models.Department)
admin.site.register(models.SQLRecord, SQLRecordAdmin)
admin.site.register(models.SQLContent)
admin.site.register(models.SQLTag)
