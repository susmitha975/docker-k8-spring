#!/bin/bash -e

declare -a opts

opts+=( "-Duser.timezone=UTC" )
opts+=( "-Dnewrelic.environment=${NEW_RELIC_ENVIRONMENT:-production}" )
opts+=( "-Djavax.net.ssl.trustStore=${TRUSTSTORE_PATH:-${JAVA_HOME}/lib/security/cacerts}" )
opts+=( "-Djavax.net.ssl.trustStorePassword=${TRUSTSTORE_PASSWD:-changeit}" )


# set meaningful defaults
PROXY_PORT=${PROXY_PORT:-3128}
NO_PROXY="${NO_PROXY:-localhost}"
NEWRELIC_VERSION=7.7.0

# OS uses comma separator, whereas JAVA uses vertical bar
NO_PROXY=$(echo -n "${NO_PROXY}" | sed -e 's/|/,/g' -e 's/ //g')
JAVA_NO_PROXY=$(echo -n "${NO_PROXY}" | sed -e 's/,/|/g' -e 's/ //g')

# add proxy options
opts+=( "-Dhttp.proxyHost=${PROXY_HOST}" )
opts+=( "-Dhttp.proxyPort=${PROXY_PORT}" )
opts+=( "-Dhttp.nonProxyHosts=${JAVA_NO_PROXY}" )
opts+=( "-Dhttps.proxyHost=${PROXY_HOST}" )
opts+=( "-Dhttps.proxyPort=${PROXY_PORT}" )

# make debugging easy
cat >> .bashrc << EOF
export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export https_proxy="https://${PROXY_HOST}:${PROXY_PORT}"
export no_proxy="${NO_PROXY}"
EOF

export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export https_proxy="https://${PROXY_HOST}:${PROXY_PORT}"
export no_proxy="${NO_PROXY}"
# add new relic config
export new_relic_param=" -javaagent:/opt/concur/newrelic/newrelic-agent-7.7.0.jar"
opts+=( " -Dnewrelic.config.high_security=${NEW_RELIC_HIGH_SECURITY}")
opts+=( " -Dnewrelic.config.license_key=${NEW_RELIC_LICENSE_KEY}")
opts+=( " -Dnewrelic.config.ca_bundle_path=${NEW_RELIC_CA_BUNDLE_PATH}")
opts+=( " -Dnewrelic.config.use_private_ssl=true")
opts+=( " -Dnewrelic.config.ssl=true")
opts+=( " -Dnewrelic.config.app_name=${NEW_RELIC_APP_NAME}")
opts+=( " -Dnewrelic.config.proxy_host=${NEW_RELIC_PROXY_HOST}")
opts+=( " -Dnewrelic.config.proxy_port=${NEW_RELIC_PROXY_PORT}")
opts+=( " -Dnewrelic.config.labels=${NEW_RELIC_LABELS}")


exec java ${JAVA_OPTS} ${new_relic_param} ${opts[*]} $@
