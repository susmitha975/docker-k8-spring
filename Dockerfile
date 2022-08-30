FROM quay.cnqr.delivery/baseimage/openjdk:11
USER concur
WORKDIR /opt/concur

ADD --chown=concur /build/libs/FizzBuzz1-1.0-SNAPSHOT.jar app.jar
ENV NEW_RELIC_HOME="/opt/concur/newrelic"
ENV CONCURDIR="/opt/concur"
RUN mkdir -p ${NEW_RELIC_HOME} ;\
    chown -R concur:concur ${NEW_RELIC_HOME} ;\
    wget -nv --no-check-certificate -O $NEW_RELIC_HOME/newrelic-agent-7.7.0.jar https://artifactory.concurtech.net/artifactory/libs-release-local/newrelic-agent/newrelic-agent/7.7.0/newrelic-agent-7.7.0.jar
RUN ls $NEW_RELIC_HOME

COPY --chown=concur start.sh .

ENV ARTIFACTORY_PATH="http://artifactory.concurtech.net/artifactory/ext-util-selfserve-local"

USER concur

EXPOSE 8080
RUN chmod +x ./start.sh
ENTRYPOINT ["/opt/concur/start.sh"]
CMD ["-jar", "app.jar"]
