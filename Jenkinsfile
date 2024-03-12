def registry = 'https://algorithmtechies.jfrog.io'
def imageName = 'algorithmtechies.jfrog.io/mydocker-docker-local/demo-workshop'
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

        stage('Jar Publish') {
                        steps {
                                script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-creds"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "target/(*)",
                              "target": "mavenrepo-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'

            }
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

