FROM weblate/weblate:4.11.2-1

# Defaults taken from https://raw.githubusercontent.com/WeblateOrg/docker-compose/main/environment
# Secret/sensitive and values that vary by environment(stage|prod) are defined in Terraform or `secrets`
# https://github.com/CruGlobal/cru-terraform/tree/master/applications/weblate

ENV WEBLATE_ADMIN_NAME="Weblate Admin"
    WEBLATE_ENABLE_HTTPS=1
    WEBLATE_IP_PROXY_HEADER=HTTP_X_FORWARDED_FOR
