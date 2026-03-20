pipeline {
    agent any
 
    tools {
        maven 'Maven-3'
    }
 
    environment {
        // ── Replace <Server1-Private-IP> with your actual Server 1 IP ──
        SONAR_URL      = 'http://35.170.50.55:9000'
        NEXUS_URL      = 'http://35.170.50.55:8081'
        NEXUS_REPO     = 'maven-snapshots'
        TOMCAT_URL     = 'http://35.170.50.55:8080'
        ARTIFACT_ID    = 'aarvitex-webapp'
        GROUP_ID       = 'com.aarvitex'
        VERSION        = '1.0-SNAPSHOT'
        PACKAGING      = 'war'
    }
 
    stages {
 
        // ═══ STAGE 1: GIT CHECKOUT ═══
        stage('Git Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: 'git_creds',
                    url: 'https://github.com/Aarvitexsathya/aarvitex-webapp.git'
            }
        }
 
        // ═══ STAGE 2: MAVEN BUILD ═══
        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests=false'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.war'
                }
            }
        }
 
        // ═══ STAGE 3: SONARQUBE ANALYSIS ═══
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \\
                          -Dsonar.projectKey=aarvitex-webapp \\
                          -Dsonar.projectName='Aarvitex WebApp' \\
                          -Dsonar.host.url=${SONAR_URL}
                    '''
                }
            }
        }
 
        // ═══ STAGE 4: UPLOAD TO NEXUS ═══
        stage('Upload to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '172.31.43.64:8081',
                    groupId: "${GROUP_ID}",
                    version: "${VERSION}",
                    repository: "${NEXUS_REPO}",
                    credentialsId: 'nexus_creds',
                    artifacts: [
                        [
                            artifactId: "${ARTIFACT_ID}",
                            classifier: '',
                            file: 'target/AarvitexWebApp.war',
                            type: "${PACKAGING}"
                        ]
                    ]
                )
            }
        }
 
        // ═══ STAGE 5: DEPLOY TO TOMCAT ═══
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'tomcat_creds',
                        path: '',
                        url: "${TOMCAT_URL}"
                    )
                ],
                contextPath: '/AarvitexWebApp',
                war: 'target/AarvitexWebApp.war'
            }
        }
    }
 
    // ═══ STAGE 6: POST-BUILD NOTIFICATIONS====
    post {
        success {
            echo 'Pipeline completed successfully!'
            echo "App live at: ${TOMCAT_URL}/AarvitexWebApp"
        }
        failure {
            echo 'Pipeline failed! Check console output.'
        }
    }
}