#ENV PROJECT_NAME=java_p1
FROM alpine/git AS source
ARG PROJECT_NAME
ENV PROJECT=${PROJECT_NAME}
WORKDIR /app
RUN git clone https://github.com/joel2064/${PROJECT}.git

FROM maven:3-eclipse-temurin-21-alpine AS builder
ARG PROJECT_NAME
ENV PROJECT=${PROJECT_NAME}
WORKDIR /app
COPY --from=source /app/${PROJECT} /app
RUN rm -f /app/target/*.jar
RUN mvn -e -B package

FROM eclipse-temurin:21-jre-alpine
COPY --from=builder /app/target/*.jar /app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app.jar"]
