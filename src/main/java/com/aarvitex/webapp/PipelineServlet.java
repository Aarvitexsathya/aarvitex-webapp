package com.aarvitex.webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * PipelineServlet — shows the CI/CD pipeline stages for classroom teaching.
 *
 * Teaching Points:
 *  - Shows how servlets can serve dynamic content without JSP
 *  - Good example for SonarQube: students can see clean, tested Java code
 *  - Used as the demo endpoint in Jenkins pipeline health checks
 *
 * Try: GET /pipeline?stage=maven
 * Used in: Session 1 through Session 7
 */
public class PipelineServlet extends HttpServlet {

    // Each stage of the pipeline — built up session by session
    private static final String[][] PIPELINE_STAGES = {
        { "maven",      "🔨", "Maven Build",      "mvn clean package",                   "done"   },
        { "sonar",      "🔍", "SonarQube",         "mvn sonar:sonar",                     "done"   },
        { "jenkins",    "⚙",  "Jenkins CI",        "Jenkinsfile — Declarative Pipeline",  "active" },
        { "docker",     "🐳", "Docker",            "docker build & docker push",          "soon"   },
        { "actions",    "▶",  "GitHub Actions",    ".github/workflows/ci.yml",            "soon"   },
        { "codepipeline","☁", "AWS CodePipeline",  "buildspec.yml + CodeDeploy",          "soon"   },
        { "kubernetes", "☸",  "Kubernetes",        "kubectl apply -f k8s/",               "soon"   },
    };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String highlight = request.getParameter("stage");

        out.println("<!DOCTYPE html><html lang='en'><head>");
        out.println("<meta charset='UTF-8'/>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'/>");
        out.println("<title>CI/CD Pipeline — Aarvitex</title>");
        out.println("<style>");
        out.println("  body{font-family:'Segoe UI',Arial,sans-serif;background:#0d1117;color:#e6edf3;margin:0;padding:40px 20px;}");
        out.println("  h1{text-align:center;color:#21a179;font-size:32px;margin-bottom:6px;}");
        out.println("  .sub{text-align:center;color:#8b949e;margin-bottom:40px;font-size:15px;}");
        out.println("  .stages{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px;}");
        out.println("  .stage{display:flex;align-items:center;gap:16px;padding:18px 24px;border-radius:12px;border:1px solid #21262d;background:#161b22;}");
        out.println("  .stage.done{border-color:#58a6ff55;background:#58a6ff08;}");
        out.println("  .stage.active{border-color:#21a179;background:#21a17912;}");
        out.println("  .stage.hl{border-color:#f0a500;background:#f0a50012;}");
        out.println("  .stage-icon{font-size:28px;min-width:40px;text-align:center;}");
        out.println("  .stage-info{flex:1;}");
        out.println("  .stage-name{font-weight:700;font-size:15px;color:#f0f6fc;margin-bottom:4px;}");
        out.println("  .stage-cmd{font-family:monospace;font-size:12px;color:#8b949e;}");
        out.println("  .badge{padding:3px 12px;border-radius:10px;font-size:11px;font-weight:600;}");
        out.println("  .badge.done{background:#58a6ff22;color:#58a6ff;}");
        out.println("  .badge.active{background:#21a17922;color:#21a179;}");
        out.println("  .badge.soon{background:#30363d;color:#8b949e;}");
        out.println("  .badge.hl{background:#f0a50022;color:#f0a500;}");
        out.println("  .back{display:block;text-align:center;margin-top:32px;color:#58a6ff;text-decoration:none;font-size:14px;}");
        out.println("  .try-links{text-align:center;margin-bottom:30px;}");
        out.println("  .try-links a{color:#21a179;font-family:monospace;font-size:13px;margin:0 10px;text-decoration:none;}");
        out.println("</style></head><body>");

        out.println("<h1>⚙ CI/CD Pipeline Stages</h1>");
        out.println("<p class='sub'>One app — seven sessions — full DevOps journey · <strong>aarvitex.com</strong></p>");

        out.println("<div class='try-links'>");
        out.println("  Try: ");
        for (String[] s : PIPELINE_STAGES) {
            out.println("  <a href='pipeline?stage=" + s[0] + "'>" + s[0] + "</a>");
        }
        out.println("</div>");

        out.println("<div class='stages'>");
        for (String[] stage : PIPELINE_STAGES) {
            String key    = stage[0];
            String icon   = stage[1];
            String name   = stage[2];
            String cmd    = stage[3];
            String status = stage[4];

            boolean isHighlighted = key.equalsIgnoreCase(highlight);
            String cssClass = isHighlighted ? "hl" : status;

            out.println("<div class='stage " + cssClass + "'>");
            out.println("  <div class='stage-icon'>" + icon + "</div>");
            out.println("  <div class='stage-info'>");
            out.println("    <div class='stage-name'>" + name + "</div>");
            out.println("    <div class='stage-cmd'>" + escapeHtml(cmd) + "</div>");
            out.println("  </div>");
            out.println("  <div class='badge " + cssClass + "'>" + (isHighlighted ? "◀ Here" : status) + "</div>");
            out.println("</div>");
        }
        out.println("</div>");
        out.println("<a href='index.jsp' class='back'>← Back to Home</a>");
        out.println("</body></html>");
    }

    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;");
    }
}
