# Step 1: Bygg Java-applikasjonen i en Maven container
FROM maven:3.8.6-openjdk-11-slim AS build

# Sett arbeidskatalogen
WORKDIR /app

# Kopier pom.xml og last ned avhengigheter først for å utnytte Docker cache
COPY pom.xml .
RUN mvn dependency:go-offline

# Kopier src-koden og bygg applikasjonen
COPY java_sqs_client/src /app/src
RUN mvn clean package -DskipTests

# Step 2: Kjør applikasjonen i et minimalt runtime-miljø
FROM openjdk:11-jre-slim

# Sett arbeidskatalogen
WORKDIR /app

# Kopier den byggede JAR-filen fra build-fasen
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

# Sett miljøvariabelen
ENV SQS_QUEUE_URL=""

# Kjør applikasjonen
ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]