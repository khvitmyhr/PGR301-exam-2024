FROM maven:3.8.6-openjdk-11-slim AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src /app/src
RUN mvn clean package -DskipTests

FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

ENV SQS_QUEUE_URL=""

ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]