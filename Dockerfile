FROM weblate/weblate:5.14.0.0

LABEL "com.datadoghq.ad.logs"='[{"source": "django", "service": "weblate"}]'

# Defaults taken from https://raw.githubusercontent.com/WeblateOrg/docker-compose/main/environment
# Secret/sensitive and values that vary by environment(stage|prod) are defined in Terraform or `secrets`
# https://github.com/CruGlobal/cru-terraform/tree/master/applications/weblate

ENV WEBLATE_ADMIN_NAME="AllTongues Translations"
ENV WEBLATE_ENABLE_HTTPS=1
ENV WEBLATE_IP_PROXY_HEADER=HTTP_X_FORWARDED_FOR
ENV WEBLATE_SERVER_EMAIL="alltongues@cru.org" 
ENV WEBLATE_DEFAULT_FROM_EMAIL="alltongues@cru.org" 
ENV WEBLATE_REQUIRE_LOGIN=1
ENV WEBLATE_REGISTRATION_OPEN=0
ENV WEBLATE_DEFAULT_ACCESS_CONTROL=100
ENV WEBLATE_DEFAULT_COMMITER_EMAIL="alltongues@cru.org"
ENV WEBLATE_DEFAULT_COMMITER_NAME="AllTongues Translations"
#ENV SENTRY_DSN="https://08d2615c0df1e1ed15f236ec42b6ded6@o4507457922662400.ingest.us.sentry.io/4507457938325504"
#ENV WEBLATE_LOCALIZE_CDN_URL="https://alltongues.org"
#ENV WEBLATE_LOCALIZE_CDN_PATH="/app/data/l10n-cdn"
#ENV CELERY_MAIN_OPTIONS="celery --app=weblate.utils worker --beat --queues=celery,notify,memory,translate,backup --pool=solo"
