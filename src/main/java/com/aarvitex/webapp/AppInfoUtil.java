package com.aarvitex.webapp;

/**
 * AppInfoUtil — Utility class for the Aarvitex WebApp.
 *
 * Teaching Purpose:
 *  This class exists primarily to demonstrate unit testing with Maven.
 *  When mvn test runs, Maven compiles AppInfoUtilTest.java and executes it.
 *  SonarQube will then measure code coverage on this class.
 *
 * Used in: Session 1 (Maven), Session 2 (SonarQube code coverage)
 */
public class AppInfoUtil {

    public static final String APP_NAME    = "Aarvitex WebApp";
    public static final String APP_VERSION = "1.0-SNAPSHOT";
    public static final String TRAINING    = "aarvitex.com";

    private AppInfoUtil() {
        // Utility class — no instantiation
    }

    /**
     * Returns a greeting message for the given name.
     * @param name the name to greet
     * @return formatted greeting string
     */
    public static String greet(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "Hello, DevOps Student!";
        }
        return "Hello, " + name.trim() + "!";
    }

    /**
     * Validates that an application version string follows semantic versioning.
     * @param version the version string (e.g. "1.0-SNAPSHOT" or "1.0.0")
     * @return true if valid
     */
    public static boolean isValidVersion(String version) {
        if (version == null || version.trim().isEmpty()) {
            return false;
        }
        return version.matches("\\d+\\.\\d+(\\.\\d+)?(-SNAPSHOT)?");
    }

    /**
     * Returns the application info as a formatted string.
     * Useful for health check endpoints and logs.
     */
    public static String getAppInfo() {
        return APP_NAME + " | Version: " + APP_VERSION + " | Training: " + TRAINING;
    }
}
