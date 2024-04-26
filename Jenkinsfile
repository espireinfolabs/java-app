def registry = 'http://172.21.86.127:8081'
def imageName = 'java-app'
def version   = '1.0.0'
pipeline {
    agent
                {
                        label 'maven'
                }

        environment
                {
                        PATH = "/usr/bin:$PATH"
                }

    stages {

        stage('Build') {
        steps {
                sh 'pwd'
                                sh 'mvn -B -DskipTests clean package'
              }
        }

         stage ('Upload and publish jar file') {
            steps {
                rtUpload (
                    buildName: JOB_NAME,
                    buildNumber: BUILD_NUMBER,
                    serverId: SERVER_ID, // Obtain an Artifactory server instance, defined in Jenkins --> Manage:
                    spec: '''{
                              "files": [
                                 {
                                  "pattern": "target/*",
                                  "target": "libs-release-local/",
                                  "recursive": "false"
                                } 
                             ]
                        }'''    
                    )
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    buildName: JOB_NAME,
                    buildNumber: BUILD_NUMBER,
                    serverId: SERVER_ID
                )
            }
        }
         stage ('Add interactive promotion') {
            steps {
                rtAddInteractivePromotion (
                    //Mandatory parameter
                    serverId: SERVER_ID,

                    //Optional parameters
                    targetRepo: 'result/',
                    displayName: 'Promote me please',
                    buildName: JOB_NAME,
                    buildNumber: BUILD_NUMBER,
                    comment: 'this is the promotion comment',
                    sourceRepo: 'result/',
                    status: 'Released',
                    includeDependencies: true,
                    failFast: true,
                    copy: true
                )

                rtAddInteractivePromotion (
                    serverId: SERVER_ID,
                    buildName: JOB_NAME,
                    buildNumber: BUILD_NUMBER
                )
            }
         }
         stage ('Removing files') {
            steps {
                sh 'rm -rf $WORKSPACE/*'
            }
        }
         
	  stage(" Docker Build ") {
		steps {
			script {
				echo '<--------------- Docker Build Started --------------->'
				app = docker.build(imageName+":"+version)
				echo '<--------------- Docker Build Ends --------------->'
			}
		}
    }

    stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'jfrog-creds'){
                    app.push()
                }    
               echo '<--------------- Docker Publish Ended --------------->'  
            }
        }
    }
  }
}
