pipeline{

    agent any

    stages{

        stage('Removing the old container and image'){
            steps{
               
               // SSH into the server
               sshagent(['Azure-practice']){
                    

                    sh '''
                        ssh -o StrictHostKeyChecking=no azureuser@20.244.105.124 '

                            # spinning down the grid
                            docker-compose down

                            # remove the test container
                            docker rm -f $(docker ps -aq)

                            # remove pos-selenium-test image
                            docker rmi pos-selenium-test


                        '
                    '''

               }


            }

        }
        
         stage('Spinning up the selenium grid'){
            steps{
               

                           
                          // SSH into the server
               sshagent(['Azure-practice']){
                    

                    sh '''
                        ssh -o StrictHostKeyChecking=no azureuser@20.244.105.124 '

                            # spinning up the grid
                            docker-compose up -d
                            
                            # Build pos-selenium-test image
                            docker build -t pos-selenium-test:latest -f sanDockerfile .
                            
                            # Delete existing reports folder
                            sudo rm -rf reports
                            
                            # Create reports folder
                            mkdir reports
                            
                            # Run the image
                            docker run -v $(pwd)/reports:/selenium/reports --name pos-sel-test-container pos-selenium-test:latest
                            
                            # include read permissions to the report files
                            sudo chmod -R +r reports/*
                            
                            # Push the reports to aws s3 bucket
                            aws s3 sync reports/ s3://myprjectreport/reports


                        '
                    '''

               }

                       
                 


            }

        }
    }

    post {
        success {
            script {
                def buildNumber = currentBuild.number
                def buildName = env.JOB_NAME
                def buildTime = new Date().format("yyyy-MM-dd HH:mm:ss")
                def customSubject = "Build: #${buildNumber} - ${buildName} - Successful"
                def customMessage = "Hi Team,\n \n" +
                                    "Build Name: ${buildName}\n" +
                                    "Build Number: ${buildNumber}\n" +
                                    "Date/Time: ${buildTime}\n" +
                                    "This is a custom message for build #${buildNumber} that was successful.\n \n" +
                                    "Regards\n" +
                                    "IT Team"

                emailext (
                    subject: customSubject, // Custom subject
                    body: customMessage, // Custom message
                    to: 'datasandhiyaprj1@gmail.com', // Replace with the recipient's email address
                    from: 'sandhiyadesai@gmail.com', // Replace with your Gmail address
                )
            }
        }
        failure {
            script {
                def buildNumber = currentBuild.number
                def buildName = env.JOB_NAME
                def buildTime = new Date().format("yyyy-MM-dd HH:mm:ss")
                def customSubject = "Build: #${buildNumber} - ${buildName} - Failed"
                def customMessage = "Hi Team,\n \n" +
                                    "Build Name: ${buildName}\n" +
                                    "Build Number: ${buildNumber}\n" +
                                    "Date/Time: ${buildTime}\n" +
                                    "This is a custom message for build #${buildNumber} that failed.\n \n" +
                                    "Regards\n" +
                                    "IT Team"

                emailext (
                    subject: customSubject, // Custom subject
                    body: customMessage, // Custom message
                    to: 'datasandhiyaprj1@gmail.com', // Replace with the recipient's email address
                    from: 'sandhiyadesai@gmail.com', // Replace with your Gmail address
                )
            }
        }
    }

}
