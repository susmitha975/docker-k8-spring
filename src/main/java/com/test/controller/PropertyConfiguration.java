package com.test.controller;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@Getter
public class PropertyConfiguration {

    @Value("#{'${service.x509.clientCertAllowlist:}'.split(',')}")
    private List<String> trustedSources;

    @Value("${service.x509.certificateJksFileName:123}")
    private String certificateJksFileName;

    @Value("${service.x509.certificateJksFilePassword:132}")
    private String certificateJksFilePassword;

    @Value("${service.x509.privateKeyStoreJksFileName:123}")
    private String privateKeyStoreJksFileName;

    @Value("${service.x509.privateKeyStoreJksFilePassword:123}")
    private String privateKeyStoreJksFilePassword;

    @Value("${service.x509.privateKeyJksPassword:123}")
    private String privateKeyJksPassword;

    @Value("${service.x509.jksPrivateClientCert:#{null}}")
    private String certPrivateKeyEncoded;

    @Value("${service.x509.jksTrustedCa:#{null}}")
    private String certTrustedCaEncoded;

    @Value("${spring.profiles.active:integration}")
    private String activeProfile;

    @Value("${http.pool.connections.max:100}")
    private int maxPoolConnectionsTotal;

    @Value("${http.pool.connections.maxPerRoute:50}")
    private int maxPoolConnectionsPerRoute;

    @Value("${http.connection.defaultKeepAliveMs:60000}")
    private int defaultKeepAliveMs;

    @Value("${http.connection.socketTimeoutMs:60000}")
    private int defaultSocketTimeoutMs;

    @Value("${http.connection.connectionTimeoutMs:20000}")
    private int defaultConnectionTimeoutMs;

    @Value("${spring.resttemplate.usessl:false}")
    private boolean useSSL;

    @Value("${service.serviceMeshEnabled:false}")
    private boolean serviceMeshEnabled;

    @Value("${pubsub.uri}")
    private String pubSubUri;

    @Value("${pubsub.topic.ess}")
    private String essTopic;

    @Value("${pubsub.eventType.ess}")
    private String essEvent;

    @Value("${pubsub.topic.receipt.available}")
    private String docComplianceAvailableTopic;

    @Value("${pubsub.eventType.receipt.available}")
    private String docComplianceAvailableEvent;

    @Value("${config.envoy.enabled:false}")
    private Boolean envoyEnabled;

    @Value("${integration.url}")
    private String integrationUrl;

    @Value("${partner.company.id}")
    private String partnerCompanyId;

    @Value("${sqs.queue.name.qualifier}")
    private String sqsQualifier;

    @Value("${dlq.max.number.messages}")
    private String maxNumberOfMessages;

    @Value("${service.concurRoute:stable}")
    private String concurRoute;
}
