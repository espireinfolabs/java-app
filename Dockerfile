	FROM openjdk:11
	ADD target/my-app-1.0-SNAPSHOT.jar demo-workshop.jar 
	ENTRYPOINT ["java", "-jar", "demo-workshop.jar"]
