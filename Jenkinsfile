// REPO_NAME & ROOT_BUILD_DIR must be as short as possible
def REPO_NAME = "s"
def ROOT_BUILD_DIR = "b"
def BUILD_NAME = "ota" //UUID.randomUUID().toString()
def INSTALLER_PATH_OFFLINE = ""
def INSTALLER_PATH_ONLINE = ""
pipeline {
    agent {
        node {
            label 'master'
            // TODO: hard drive letter should be loaded from ${env.SystemDrive} but node can't access env
            customWorkspace "C:/${REPO_NAME}"
        }
    }
    stages {
        stage('Build') {
            steps {
                sh "${env.workspace}/deployment/Strata2/release_app.sh -c -g -n -s -r '${env.workspace}/${ROOT_BUILD_DIR}' -d '${BUILD_NAME}' -f PROD"
            }
        }
        stage('Test') {
            steps {
                script{
                    INSTALLER_PATH_OFFLINE = sh(encoding: 'UTF-8', script: "find '${env.workspace}/${ROOT_BUILD_DIR}/${BUILD_NAME}' -type f  -iname 'strata-setup-offline.*' ", returnStdout: true)
                    INSTALLER_PATH_OFFLINE = INSTALLER_PATH_OFFLINE.minus("\n")
                    INSTALLER_PATH_ONLINE = sh(encoding: 'UTF-8', script: "find '${env.workspace}/${ROOT_BUILD_DIR}/${BUILD_NAME}' -type f  -iname 'strata-setup-online.*' ", returnStdout: true)
                    INSTALLER_PATH_ONLINE = INSTALLER_PATH_ONLINE.minus("\n")
                }
                echo "Installer Path Offline: $INSTALLER_PATH_OFFLINE"
                echo "Installer Path Online: $INSTALLER_PATH_ONLINE"
            }
        }
        stage('Deploy') {
            steps {
                sh "python -m pip install -r deployment/Strata2/requirements.txt"
                sh """python 'deployment/Strata2/deploy_build.py' \
                    --dir '${BUILD_NAME}' \
                    --repo '${ROOT_BUILD_DIR}/${BUILD_NAME}/public/repository/strata' \
                    """
                    //--offline '${INSTALLER_PATH_OFFLINE}' \
                    //--online '${INSTALLER_PATH_ONLINE}' \
                archiveArtifacts artifacts: "${ROOT_BUILD_DIR}/${BUILD_NAME}/strata-setup-*", onlyIfSuccessful: true
            }
        }
    }
}