# Multi-stage Dockerfile for Discovery-Server
# Builds the Spring Boot fat jar using a Gradle builder image, then runs it on a slim JRE image.

# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM gradle:8.10-jdk21 AS builder
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon

# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 9000
ENTRYPOINT ["java", "-jar", "app.jar"]
