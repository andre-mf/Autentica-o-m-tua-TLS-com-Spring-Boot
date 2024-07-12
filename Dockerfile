FROM gradle:8.8-jdk17-alpine AS build
WORKDIR /app
COPY src src
COPY build.gradle settings.gradle ./
RUN gradle clean build

FROM openjdk:17-jdk-slim-buster
WORKDIR /app
COPY --from=build /app/build/libs/springmtls-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "springmtls-0.0.1-SNAPSHOT.jar"]
EXPOSE 8443