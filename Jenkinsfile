pipeline {
    agent any 

    stages {
        stage('Build') {
            steps {
                // Run PowerShell commands to build the environment
                powershell '''
                    # Check if Directory is present and remove it
                    Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue
                    
                    # Create a build folder
                    $buildFolder = "build"
                    New-Item -ItemType Directory -Path $buildFolder -Force

                    # Create build.txt file inside the build folder
                    $buildFilePath = Join-Path -Path $buildFolder -ChildPath "car.txt"
                    New-Item -ItemType File -Path $buildFilePath -Force

                    # Add words to build.txt file
                    "chassis" | Out-File -FilePath $buildFilePath -Append
                    "engine" | Out-File -FilePath $buildFilePath -Append
                    "body" | Out-File -FilePath $buildFilePath -Append
                '''
            }
        }

        stage('Test') {
            steps {
                // PowerShell to test if car.txt exists and if it contains the word 'chassis'
                powershell '''
                    # Check if the car.txt file exists
                    if (Test-Path -Path "build/car.txt") {
                        Write-Host "build.txt exists."
                        
                        # Search for the word 'chassis' in the car.txt file
                        $searchResult = Select-String -Path "build/car.txt" -Pattern "chassis"
                        
                        if ($searchResult) {
                            Write-Host "'chassis' found in car.txt."
                        } else {
                            Write-Host "'chassis' not found in car.txt."
                            exit 1  # Fail the build if 'chassis' is not found
                        }
                    } else {
                        Write-Host "car.txt does not exist."
                        exit 1  # Fail the build if car.txt does not exist
                    }
                '''
            }
        }
        stage('Publish'){
            steps {
                archiveArtifacts artifacts: 'build/'
            }
        }
    }

    post {
        success {
            echo 'Build and Test completed successfully!'
        }
        failure {
            echo 'Build or Test failed.'
        }
    }
}
