# Aarvitex WebApp 🚀

**DevOps Training Application — [aarvitex.com](https://aarvitex.com)**

A Java Maven web application used as the single, consistent demo project throughout the Aarvitex DevOps training course — from Maven build all the way to Kubernetes deployment.

---

## 📋 Course Roadmap

| Session | Tool | What You Learn |
|---------|------|----------------|
| 1 | **Maven** | Build `AarvitexWebApp.war` from source |
| 2 | **SonarQube** | Static code analysis + Quality Gates |
| 3 | **Jenkins** | Automate build → test → scan → deploy |
| 4 | **Docker** | Containerize the WAR file |
| 5 | **GitHub Actions** | Full CI/CD pipeline on every push |
| 6 | **AWS CodePipeline** | Deploy to EC2/ECS via AWS-native pipeline |
| 7 | **Kubernetes (EKS)** | Scale the container on Amazon EKS |

---

## 🗂 Project Structure

```
aarvitex-webapp/
├── pom.xml                         ← Maven build config + dependencies
├── Dockerfile                      ← Docker session
├── Jenkinsfile                     ← Jenkins session
├── sonar-project.properties        ← SonarQube session
├── README.md
└── src/
    ├── main/
    │   ├── java/com/aarvitex/webapp/
    │   │   ├── HelloServlet.java       ← Demo servlet at /hello
    │   │   ├── PipelineServlet.java    ← Pipeline info at /pipeline
    │   │   └── AppInfoUtil.java        ← Utility class (for unit tests)
    │   └── webapp/
    │       ├── index.jsp               ← Main homepage
    │       └── WEB-INF/
    │           └── web.xml             ← Servlet mappings
    └── test/
        └── java/com/aarvitex/webapp/
            └── AppInfoUtilTest.java    ← JUnit tests (run by Maven)
```

---

## ⚡ Quick Start

### Prerequisites
- Java 11+
- Maven 3.6+
- Tomcat 9 (for deployment)

### Build
```bash
git clone https://github.com/YOUR_USERNAME/aarvitex-webapp.git
cd aarvitex-webapp
mvn clean package
```

### Run Tests
```bash
mvn test
```

### Deploy to Tomcat
```bash
cp target/AarvitexWebApp.war /opt/tomcat9/webapps/
# Access at: http://localhost:8080/AarvitexWebApp
```

### SonarQube Analysis
```bash
mvn sonar:sonar \
  -Dsonar.host.url=http://<SONAR-IP>:9000 \
  -Dsonar.login=<YOUR-TOKEN>
```

### Docker
```bash
mvn clean package
docker build -t aarvitex-webapp .
docker run -d -p 8080:8080 aarvitex-webapp
# Access at: http://localhost:8080/AarvitexWebApp
```

---

## 🌐 Application Pages

| URL | Description |
|-----|-------------|
| `/AarvitexWebApp/` | Main homepage |
| `/AarvitexWebApp/hello` | HelloServlet demo |
| `/AarvitexWebApp/hello?name=YourName` | Personalized greeting |
| `/AarvitexWebApp/pipeline` | CI/CD pipeline stage viewer |
| `/AarvitexWebApp/pipeline?stage=jenkins` | Highlight a specific stage |

---

## 🏫 About Aarvitex

This project is maintained by **[Aarvitex.com](https://aarvitex.com)** for online tech training.  
Used in the AWS & DevOps professional upskilling program.
