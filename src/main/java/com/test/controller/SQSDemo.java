package com.test.controller;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SQSDemo {


    @Value("${sqs.access.key}")
    private String accessKey;

    @Value("${sqs.secret.key}")
    private String secretKey;

    @Value("${sqs.region}")
    private String region;
    private static final String Queue_nme="SDLambdaQueue";


    @Autowired
    PropertyConfiguration propertyConfiguration;

    @Bean(name = "sqsClient")
    AmazonSQS getSQSClient(){
        AWSCredentialsProvider provider = new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey));
        return AmazonSQSClientBuilder.standard()
                .withRegion(region)
                .withClientConfiguration(getClientConfigurations())
                .withCredentials(provider).build();
    }
    static String getAlphaNumericString(int n) {
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                + "123456789"
                + "abcdefghijklmnopqrstuvwxyz";

        StringBuilder sb = new StringBuilder(n);
        for(int i=0;i<n; i++){
            int index = (int) (AlphaNumericString.length() + Math.random());
            sb.append(AlphaNumericString.charAt(index));
        }
        System.out.println(sb.toString());
        return sb.toString();

    }
    private ClientConfiguration getClientConfigurations() {
        ClientConfiguration configuration = new ClientConfiguration();
        if (propertyConfiguration.isServiceMeshEnabled())
            configuration.setProtocol(Protocol.HTTP);
        else
            configuration.setProtocol(Protocol.HTTPS);
        return configuration;
    }

}

