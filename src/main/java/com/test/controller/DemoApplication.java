package com.test.controller;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.AmazonSQSException;
import com.amazonaws.services.sqs.model.CreateQueueRequest;
import com.amazonaws.services.sqs.model.CreateQueueResult;
import com.amazonaws.services.sqs.model.SendMessageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.amazonaws.services.sqs.AmazonSQS;

@SpringBootApplication
@RestController
public class DemoApplication {

	private static final String Queue_nme="SDLambdaQueue";
	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
	@Autowired
	private AmazonSQS sqsClient;

  @GetMapping("/hi")
	public String home(){
//	  CreateQueueRequest createStandardQueueRequest = new CreateQueueRequest(Queue_nme);
	  try{

//		  CreateQueueResult create_result=sqsClient.createQueue(Queue_nme);

	  }
	  catch (AmazonSQSException e){
		  if(e.getErrorCode().equals("QueueAlreadyExists")){
			  throw  e;

		  }

	  }
//	  String standardQueueUrl = sqsClient.createQueue(createStandardQueueRequest).getQueueUrl();
//	  String queueUrl = sqsClient.getQueueUrl(Queue_nme).getQueueUrl();
//	  SendMessageRequest send_msg_request= new SendMessageRequest()
//			  .withQueueUrl(standardQueueUrl)
//			  .withMessageBody("product shipped"+""+SQSDemo.getAlphaNumericString(100));
//	  sqsClient.sendMessage(send_msg_request);
//	  System.out.println(send_msg_request);
		return "hello testing!!";


  }
}
