# Step 1: Bygg Java-applikasjonen i en Maven container
FROM maven:3.8.6-openjdk-11-slim AS build

WORKDIR /app

# Kopier pom.xml fra java_sqs_client-mappen og last ned avhengigheter
COPY java_sqs_client/pom.xml .
RUN mvn dependency:go-offline

# Kopier src-koden fra java_sqs_client-mappen
COPY java_sqs_client/src /app/src
RUN mvn clean package -DskipTests

# Step 2: Kjør applikasjonen i et minimalt runtime-miljø
FROM openjdk:11-jre-slim

WORKDIR /app

# Kopier den byggede JAR-filen fra build-fasen
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

ENV SQS_QUEUE_URL=""

ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]
