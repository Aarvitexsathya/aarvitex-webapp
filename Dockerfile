# ─────────────────────────────────────────────────────────────────
#  Aarvitex WebApp — Dockerfile
#  Used in: Session 4 (Docker), Session 5 (GitHub Actions),
#           Session 6 (CodePipeline), Session 7 (Kubernetes)
# ─────────────────────────────────────────────────────────────────
#
#  Teaching Points:
#   1. We use the official Tomcat 9 image (no need to install Tomcat manually)
#   2. The WAR file built by Maven is copied into the Tomcat webapps directory
#   3. Tomcat auto-deploys any WAR placed in /usr/local/tomcat/webapps/
#   4. The container exposes port 8080 (Tomcat default)
#
#  Build:   docker build -t aarvitex-webapp .
#  Run:     docker run -d -p 8080:8080 aarvitex-webapp
#  Access:  http://localhost:8080/AarvitexWebApp
# ─────────────────────────────────────────────────────────────────

# Base image: Official Tomcat 9 on JDK 11
FROM tomcat:9.0-jdk11-openjdk-slim

# Metadata labels (best practice)
LABEL maintainer="aarvitex.com"
LABEL description="Aarvitex DevOps Training WebApp"
LABEL version="1.0"

# Remove default Tomcat sample apps (security best practice)
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# Copy the WAR file built by Maven into Tomcat webapps
# The WAR name (AarvitexWebApp) becomes the context path in the URL
COPY target/AarvitexWebApp.war /usr/local/tomcat/webapps/AarvitexWebApp.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat (default CMD from base image, stated explicitly for clarity)
CMD ["catalina.sh", "run"]
