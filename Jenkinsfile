pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Check out the code from the repository
                checkout scm
            }
        }

        stage('Prepare') {
            steps {
                script {
                    // List files in the scripts directory using PowerShell
                    echo "Listing files in the scripts directory..."
                    def scriptsDir = 'scripts'
                    powershell """
                        Get-ChildItem -Path '${scriptsDir}' -Force
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Checking for SQL files in the 'scripts' directory..."

                    // Define the path to the scripts folder
                    def scriptsDir = 'scripts'

                    // Find SQL files in the scripts directory
                    def sqlFiles = findFiles(glob: "${scriptsDir}/*.sql")

                    // Output debug information
                    echo "Found files: " + sqlFiles.collect { it.path }.join(', ')

                    // Check if any SQL files are found
                    if (sqlFiles.length == 0) {
                        error("No SQL files found in the '${scriptsDir}' directory.")
                    } else {
                        echo "${sqlFiles.length} SQL files found in the '${scriptsDir}' directory."

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
                    def server = 'AJSERVER' // Your SQL Server address
                    def database = 'TEST_DB' // Your target database name
                    def username = 'sa'      // Your SQL Server username
                    def password = 'Sa123'   // Your SQL Server password

                    // Define the path to the scripts folder
                    def scriptsDir = 'scripts'

                    // Find SQL files in the scripts directory
                    def sqlFiles = findFiles(glob: "${scriptsDir}/*.sql")

                    if (sqlFiles.length == 0) {
                        error("No SQL scripts found for deployment.")
                    }

                    sqlFiles.each { file ->
                        def fileName = file.name
                        echo "Running SQL script: ${fileName}"

                        // Execute each SQL file using sqlcmd
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
