FROM gradle:9.7.0-jdk17 AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
RUN gradle build --no-daemon -x test || return 0
COPY src ./src
RUN gradle build --no-daemon -x test

FROM amazoncorretto:17-alpine-jdk
WORKDIR /app
COPY --from=build /app/build/libs/docker-exercises-project-1.0-SNAPSHOT.jar /app
CMD [ "java", "-jar", "./docker-exercises-project-1.0-SNAPSHOT.jar" ]
