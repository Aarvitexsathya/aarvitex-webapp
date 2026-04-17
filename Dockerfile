# ── Stage 1: Build the WAR using Maven ──────────────────────
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src/ ./src/
RUN mvn clean package -DskipTests

# ── Stage 2: Package into Tomcat runtime image ───────────────
FROM tomcat:9.0.117-jdk17

LABEL maintainer="sathya@aarvitex.com"

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage
COPY --from=builder /app/target/AarvitexWebApp.war /usr/local/tomcat/webapps/WebApp.war

EXPOSE 8080
CMD ["catalina.sh", "run"]