pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = 'ghcr.io/nonok32/devops'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                sh 'python3 -m venv .venv_ci'
                sh '. .venv_ci/bin/activate && python -m pip install --upgrade pip'
                sh '. .venv_ci/bin/activate && pip install -r requirements.txt'
            }
        }

        stage('Tests') {
            steps {
                sh '. .venv_ci/bin/activate && pytest --cov=main --cov-config=.coveragerc --cov-report=term-missing --cov-report=xml'
            }
        }


        stage('Archive coverage') {
            steps {
                archiveArtifacts artifacts: 'coverage.xml', onlyIfSuccessful: false
            }
        }

        stage('Build image') {
            steps {
                script {
                    env.IMAGE_TAG = (env.BRANCH_NAME == 'main') ? 'latest' : "sha-${env.GIT_COMMIT?.take(7)}"
                    if (!env.BUILD_NUMBER) {
                        env.IMAGE_TAG = "local-${env.GIT_COMMIT ?: 'dev'}"
                    }
                }
                sh "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
            }
        }

        stage('Push image (optional)') {
            when {
                allOf {
                    expression { return env.BRANCH_NAME == 'main' }
                    expression { return env.GHCR_TOKEN != null && env.GHCR_USER != null }
                }
            }
            steps {
                sh "echo ${env.GHCR_TOKEN} | docker login ghcr.io -u ${env.GHCR_USER} --password-stdin"
                sh "docker tag ${env.IMAGE_NAME}:${env.IMAGE_TAG} ${env.IMAGE_NAME}:sha-${env.GIT_COMMIT}"
                sh "docker push ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                sh "docker push ${env.IMAGE_NAME}:sha-${env.GIT_COMMIT}"
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f || true'
            cleanWs()
        }
    }
}
