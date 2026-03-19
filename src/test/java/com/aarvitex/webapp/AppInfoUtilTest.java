package com.aarvitex.webapp;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * AppInfoUtilTest — Unit tests for AppInfoUtil.
 *
 * Teaching Purpose:
 *  - Maven runs these tests automatically during the `test` phase
 *  - SonarQube measures how much of AppInfoUtil.java is covered by these tests
 *  - Good demonstration of: what tests Maven runs, and what SonarQube reports
 *
 * Run manually: mvn test
 * Run with output: mvn test -Dtest=AppInfoUtilTest
 *
 * Used in: Session 1 (Maven test phase), Session 2 (SonarQube coverage)
 */
public class AppInfoUtilTest {

    @Test
    public void testGreetWithName() {
        String result = AppInfoUtil.greet("Sathya");
        assertEquals("Hello, Sathya!", result);
    }

    @Test
    public void testGreetWithNull() {
        String result = AppInfoUtil.greet(null);
        assertEquals("Hello, DevOps Student!", result);
    }

    @Test
    public void testGreetWithEmptyString() {
        String result = AppInfoUtil.greet("   ");
        assertEquals("Hello, DevOps Student!", result);
    }

    @Test
    public void testValidVersionSnapshot() {
        assertTrue(AppInfoUtil.isValidVersion("1.0-SNAPSHOT"));
    }

    @Test
    public void testValidVersionRelease() {
        assertTrue(AppInfoUtil.isValidVersion("1.0.0"));
        assertTrue(AppInfoUtil.isValidVersion("2.3"));
    }

    @Test
    public void testInvalidVersionNull() {
        assertFalse(AppInfoUtil.isValidVersion(null));
    }

    @Test
    public void testInvalidVersionEmpty() {
        assertFalse(AppInfoUtil.isValidVersion(""));
    }

    @Test
    public void testInvalidVersionFormat() {
        assertFalse(AppInfoUtil.isValidVersion("v1.0"));
        assertFalse(AppInfoUtil.isValidVersion("latest"));
    }

    @Test
    public void testGetAppInfo() {
        String info = AppInfoUtil.getAppInfo();
        assertNotNull(info);
        assertTrue(info.contains("Aarvitex WebApp"));
        assertTrue(info.contains("aarvitex.com"));
    }
}
