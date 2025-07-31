pipeline {
  agent any

  stages {
    stage('Verificar Docker') {
      steps {
        sh 'docker info'
      }
    }

    // stage('Sonarqube') {
    //   steps {
    //     script {
    //       docker.image('sonarsource/sonar-scanner-cli').inside('--network docker_ci-network') {
    //         sh 'sonar-scanner'
    //       }
    //     }
    //   }
    // }

    stage('Docker build') {
      steps {
        sh 'docker build -t jenkins-laravel .'
      }
    }

    stage('Run test') {
       steps {
         sh 'docker run --rm jenkins-laravel ./vendor/bin/phpunit tests'
       }
    }

    // stage('Deploy') {
    //   steps {
    //     sshagent(credentials: ['71a7ee52-1c6a-476a-860f-6070ab4eb875']) {
    //       sh './deploy.sh'
    //     }
    //   }
    // }
  }

  post {
    success {
      // Teams notification
      script {
        def webhook = 'TU_WEBHOOK_URL_DE_TEAMS'
        def message = [
          "@type": "MessageCard",
          "@context": "http://schema.org/extensions",
          "themeColor": "00FF00",
          "summary": "Build Success",
          "sections": [[
            "activityTitle": "✅ Build Successful",
            "activitySubtitle": "${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
            "facts": [
              ["name": "Job", "value": "${env.JOB_NAME}"],
              ["name": "Build", "value": "${env.BUILD_NUMBER}"],
              ["name": "Status", "value": "SUCCESS"]
            ],
            "markdown": true
          ]],
          "potentialAction": [[
            "@type": "OpenUri",
            "name": "View Build",
            "targets": [["os": "default", "uri": "${env.BUILD_URL}"]]
          ]]
        ]
        
        httpRequest(
          httpMode: 'POST',
          contentType: 'APPLICATION_JSON',
          requestBody: groovy.json.JsonOutput.toJson(message),
          url: webhook
        )
      }
      
      // Email notification
      emailext (
        subject: "✅ Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
        body: """
        <h2>Build Successful!</h2>
        <p><strong>Job:</strong> ${env.JOB_NAME}</p>
        <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
        <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
        <p>All tests passed successfully!</p>
        """,
        mimeType: 'text/html',
        to: 'tu-email@outlook.com'
      )
    }

    failure {
      // Teams notification
      script {
        def webhook = 'TU_WEBHOOK_URL_DE_TEAMS'
        def message = [
          "@type": "MessageCard",
          "@context": "http://schema.org/extensions",
          "themeColor": "FF0000",
          "summary": "Build Failed",
          "sections": [[
            "activityTitle": "❌ Build Failed",
            "activitySubtitle": "${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
            "facts": [
              ["name": "Job", "value": "${env.JOB_NAME}"],
              ["name": "Build", "value": "${env.BUILD_NUMBER}"],
              ["name": "Status", "value": "FAILED"]
            ],
            "markdown": true
          ]],
          "potentialAction": [[
            "@type": "OpenUri",
            "name": "View Build",
            "targets": [["os": "default", "uri": "${env.BUILD_URL}"]]
          ]]
        ]
        
        httpRequest(
          httpMode: 'POST',
          contentType: 'APPLICATION_JSON',
          requestBody: groovy.json.JsonOutput.toJson(message),
          url: webhook
        )
      }
      
      // Email notification
      emailext (
        subject: "❌ Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
        body: """
        <h2>Build Failed!</h2>
        <p><strong>Job:</strong> ${env.JOB_NAME}</p>
        <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
        <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
        <p>Please check the logs for details.</p>
        """,
        mimeType: 'text/html',
        to: 'tu-email@outlook.com'
      )
    }
  }
}