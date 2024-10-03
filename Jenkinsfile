pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                checkout scm
                script {
                    // List files in the base directory using PowerShell
                    powershell """
                        Get-ChildItem -Path '.' -Force
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // List the directory contents before searching for SQL files
                    echo "Listing files in the base directory..."
                    powershell """
                        Get-ChildItem -Path '.' -Force
                    """

                    // Find SQL files in the base directory
                    def sqlFiles = findFiles(glob: '*.sql')
                    
                    // Output debug information
                    echo "Found files: " + sqlFiles.collect { it.path }.join(', ')

                    // Check if any SQL files are found
                    if (sqlFiles.length == 0) {
                        error("No SQL files found in the base directory.")
                    } else {
                        echo "${sqlFiles.length} SQL files found in the base directory."

                        // Validate that SQL files are named with numbers
                        def invalidFiles = []
                        sqlFiles.each { file ->
                            if (!(file.name ==~ /^\d+\.sql$/)) {
                                invalidFiles.add(file.name)
                            }
                        }

                        if (invalidFiles.size() > 0) {
                            error("The following SQL files are not named with numbers: ${invalidFiles.join(', ')}")
                        } else {
                            echo "All SQL files are correctly named with numbers."
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def server = 'AJSERVER' 
                    def database = 'TEST_DB' 
                    def username = 'sa' 
                    def password = 'Sa123'

                    // Find SQL files in the base directory
                    def sqlFiles = findFiles(glob: '*.sql')

                    if (sqlFiles.length == 0) {
                        error("No SQL scripts found for deployment.")
                    }

                    sqlFiles.each { file ->
                        def fileName = file.name
                        echo "Running SQL script: ${fileName}"

                        powershell """
                            sqlcmd -S ${server} -d ${database} -U ${username} -P ${password} -i '${file.path}'
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
