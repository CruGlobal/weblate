FROM weblate/weblate:4.17-2

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