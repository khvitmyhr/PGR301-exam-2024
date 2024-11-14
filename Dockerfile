FROM maven:3.8-eclipse-temurin-17 as builder
WORKDIR /app
COPY java_sqs_client/pom.xml .
COPY java_sqs_client/src ./src
RUN mvn package

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/application.jar
ENTRYPOINT ["java", "-jar", "/app/application.jar"]