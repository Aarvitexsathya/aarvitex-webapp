<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Aarvitex DevOps Training for jan5th— WebApp</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: #0d1117;
      color: #e6edf3;
      min-height: 100vh;
    }

    /* ── HEADER ── */
    header {
      background: linear-gradient(135deg, #161b22 0%, #1f2937 100%);
      border-bottom: 2px solid #21a179;
      padding: 18px 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .logo {
      font-size: 22px;
      font-weight: 700;
      color: #21a179;
      letter-spacing: 1px;
    }
    .logo span { color: #58a6ff; }
    .build-badge {
      background: #21a17922;
      border: 1px solid #21a179;
      color: #21a179;
      padding: 5px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-family: monospace;
    }

    /* ── HERO ── */
    .hero {
      text-align: center;
      padding: 70px 20px 50px;
    }
    .hero-tag {
      display: inline-block;
      background: #21a17922;
      color: #21a179;
      border: 1px solid #21a17955;
      padding: 5px 16px;
      border-radius: 20px;
      font-size: 12px;
      letter-spacing: 2px;
      text-transform: uppercase;
      margin-bottom: 20px;
    }
    .hero h1 {
      font-size: 48px;
      font-weight: 800;
      color: #f0f6fc;
      line-height: 1.2;
      margin-bottom: 16px;
    }
    .hero h1 .highlight { color: #21a179; }
    .hero p {
      font-size: 18px;
      color: #8b949e;
      max-width: 600px;
      margin: 0 auto 36px;
      line-height: 1.6;
    }
    .hero-buttons {
      display: flex;
      gap: 14px;
      justify-content: center;
      flex-wrap: wrap;
    }
    .btn {
      padding: 12px 28px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.2s;
      cursor: pointer;
      border: none;
    }
    .btn-primary {
      background: #21a179;
      color: #fff;
    }
    .btn-primary:hover { background: #1a8a65; }
    .btn-secondary {
      background: transparent;
      color: #58a6ff;
      border: 1px solid #58a6ff;
    }
    .btn-secondary:hover { background: #58a6ff22; }

    /* ── PIPELINE SECTION ── */
    .pipeline-section {
      background: #161b22;
      border-top: 1px solid #21262d;
      border-bottom: 1px solid #21262d;
      padding: 50px 40px;
      text-align: center;
    }
    .section-title {
      font-size: 13px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: #8b949e;
      margin-bottom: 12px;
    }
    .section-heading {
      font-size: 28px;
      font-weight: 700;
      color: #f0f6fc;
      margin-bottom: 10px;
    }
    .section-sub {
      font-size: 15px;
      color: #8b949e;
      margin-bottom: 40px;
    }
    .pipeline-steps {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-wrap: wrap;
      gap: 0;
      max-width: 1000px;
      margin: 0 auto;
    }
    .step {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      min-width: 90px;
    }
    .step-icon {
      width: 56px;
      height: 56px;
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      font-weight: 700;
      border: 2px solid;
    }
    .step-label {
      font-size: 12px;
      font-weight: 600;
      color: #8b949e;
      text-align: center;
    }
    .step-arrow {
      color: #30363d;
      font-size: 20px;
      padding: 0 4px;
      margin-bottom: 24px;
    }
    .step.active .step-icon { border-color: #21a179; background: #21a17922; color: #21a179; }
    .step.done .step-icon   { border-color: #58a6ff; background: #58a6ff22; color: #58a6ff; }
    .step.soon .step-icon   { border-color: #30363d; background: #161b22;   color: #8b949e; }
    .step.active .step-label { color: #21a179; }
    .step.done .step-label   { color: #58a6ff; }

    /* ── INFO CARDS ── */
    .cards-section {
      padding: 60px 40px;
      max-width: 1100px;
      margin: 0 auto;
    }
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
    }
    .card {
      background: #161b22;
      border: 1px solid #21262d;
      border-radius: 12px;
      padding: 28px;
      transition: border-color 0.2s;
    }
    .card:hover { border-color: #21a17955; }
    .card-icon { font-size: 28px; margin-bottom: 14px; }
    .card h3 { font-size: 16px; font-weight: 700; color: #f0f6fc; margin-bottom: 8px; }
    .card p { font-size: 14px; color: #8b949e; line-height: 1.6; }
    .card .tag {
      display: inline-block;
      background: #21a17922;
      color: #21a179;
      padding: 2px 10px;
      border-radius: 10px;
      font-size: 11px;
      margin-top: 12px;
    }

    /* ── LIVE INFO BAR ── */
    .info-bar {
      background: #161b22;
      border-top: 1px solid #21262d;
      padding: 18px 40px;
      display: flex;
      gap: 40px;
      flex-wrap: wrap;
      justify-content: center;
    }
    .info-item { font-size: 13px; color: #8b949e; font-family: monospace; }
    .info-item span { color: #21a179; }

    /* ── FOOTER ── */
    footer {
      text-align: center;
      padding: 24px;
      font-size: 13px;
      color: #30363d;
      border-top: 1px solid #21262d;
    }
    footer a { color: #58a6ff; text-decoration: none; }
  </style>
</head>
<body>

  <!-- HEADER -->
  <header>
    <div class="logo">AARVITEX<span>.com</span></div>
    <div class="build-badge">✓ BUILD: SUCCESS &nbsp;|&nbsp; v1.0-SNAPSHOT</div>
  </header>

  <!-- HERO -->
  <section class="hero">
    <div class="hero-tag">DevOps Training — Live Demo App</div>
    <h1>Welcome to<br/><span class="highlight">Aarvitex WebApp</span></h1>
    <p>
      This Java web application is your learning companion through the entire
      DevOps pipeline — from Maven build to Kubernetes deployment.
    </p>
    <div class="hero-buttons">
      <a href="hello" class="btn btn-primary">👋 Hello Servlet</a>
      <a href="pipeline" class="btn btn-secondary">⚙ View Pipeline Info</a>
    </div>
  </section>

  <!-- PIPELINE JOURNEY -->
  <section class="pipeline-section">
    <div class="section-title">Your Learning Journey</div>
    <div class="section-heading">From Code to Cloud — One App, Every Step</div>
    <div class="section-sub">Each session adds a new layer to this same application</div>

    <div class="pipeline-steps">
      <div class="step done">
        <div class="step-icon">🔨</div>
        <div class="step-label">Maven<br/>Build</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step done">
        <div class="step-icon">🔍</div>
        <div class="step-label">Sonar<br/>Qube</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step active">
        <div class="step-icon">⚙</div>
        <div class="step-label">Jenkins<br/>CI</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step soon">
        <div class="step-icon">🐳</div>
        <div class="step-label">Docker<br/>Image</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step soon">
        <div class="step-icon">▶</div>
        <div class="step-label">GitHub<br/>Actions</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step soon">
        <div class="step-icon">☁</div>
        <div class="step-label">Code<br/>Pipeline</div>
      </div>
      <div class="step-arrow">→</div>
      <div class="step soon">
        <div class="step-icon">☸</div>
        <div class="step-label">Kuberne<br/>tes</div>
      </div>
    </div>
  </section>

  <!-- CARDS -->
  <section class="cards-section">
    <div class="cards-grid">

      <div class="card">
        <div class="card-icon">🔨</div>
        <h3>Maven Build</h3>
        <p>
          This WAR file was built using <code>mvn clean package</code>.
          Maven compiled the Java sources, ran tests, and packaged everything
          into <strong>AarvitexWebApp.war</strong>.
        </p>
        <span class="tag">Session 1 — Completed</span>
      </div>

      <div class="card">
        <div class="card-icon">🔍</div>
        <h3>SonarQube Analysis</h3>
        <p>
          The source code is scanned by SonarQube for bugs, vulnerabilities,
          and code smells. A Quality Gate decides whether the build can proceed.
        </p>
        <span class="tag">Session 2 — Completed</span>
      </div>

      <div class="card">
        <div class="card-icon">⚙</div>
        <h3>Jenkins Pipeline</h3>
        <p>
          A Jenkinsfile in this repo defines the CI/CD pipeline — Git pull →
          Maven build → SonarQube scan → Deploy to Tomcat — all automated.
        </p>
        <span class="tag">Session 3 — Next</span>
      </div>

      <div class="card">
        <div class="card-icon">🐳</div>
        <h3>Docker Container</h3>
        <p>
          The Dockerfile in this repo packages the WAR file into a Tomcat
          container image, making it portable across any environment.
        </p>
        <span class="tag">Session 4 — Coming Soon</span>
      </div>

      <div class="card">
        <div class="card-icon">▶</div>
        <h3>GitHub Actions</h3>
        <p>
          A workflow file automates the full pipeline on every git push —
          build, test, scan, containerize, and push to Docker Hub.
        </p>
        <span class="tag">Session 5 — Coming Soon</span>
      </div>

      <div class="card">
        <div class="card-icon">☸</div>
        <h3>Kubernetes (EKS)</h3>
        <p>
          Kubernetes manifests deploy and scale the Docker container on
          Amazon EKS — the final destination of this DevOps journey.
        </p>
        <span class="tag">Session 7 — Coming Soon</span>
      </div>

    </div>
  </section>

  <!-- INFO BAR -->
  <div class="info-bar">
    <div class="info-item">App: <span>AarvitexWebApp.war</span></div>
    <div class="info-item">Java Version: <span><%= System.getProperty("java.version") %></span></div>
    <div class="info-item">Server: <span><%= application.getServerInfo() %></span></div>
    <div class="info-item">Loaded: <span><%= new Date() %></span></div>
    <div class="info-item">Training: <span>aarvitex.com</span></div>
  </div>

  <!-- FOOTER -->
  <footer>
    Built for <a href="https://aarvitex.com" target="_blank">Aarvitex.com</a> DevOps Training &nbsp;|&nbsp;
    Java + Maven + Tomcat &nbsp;|&nbsp; &copy; <%= new java.util.Calendar.Builder().build().get(java.util.Calendar.YEAR) %> Aarvitex
  </footer>

</body>
</html>
