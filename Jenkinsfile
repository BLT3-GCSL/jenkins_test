pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                checkout scm
                script {
                    echo "Listing files in the scripts directory..."
                    powershell """
                        Get-ChildItem -Path 'scripts' -Force
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Checking for SQL files in the 'scripts' directory..."
                    def sqlFiles = findFiles(glob: 'scripts/*.sql')
                    echo "Found files: " + sqlFiles.collect { it.path }.join(', ')

                    if (sqlFiles.length == 0) {
                        error("No SQL files found in the 'scripts' directory.")
                    } else {
                        echo "${sqlFiles.length} SQL files found in the 'scripts' directory."
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
                    def logFile = 'sql_execution_log.txt'
                    def errorMessages = []

                    // Find SQL files in the scripts directory
                    def sqlFiles = findFiles(glob: 'scripts/*.sql')

                    sqlFiles.each { file ->
                        def fileName = file.name
                        echo "Running SQL script: ${fileName}"

                        // Execute SQL script and capture output
                        def output = powershell(script: """
                            sqlcmd -S ${server} -d ${database} -U ${username} -P ${password} -i '${file.path}' -b 2>&1
                        """, returnStdout: true).trim()

                        // Write output to the log file
                        writeFile(file: logFile, text: output, append: true)

                        // Print output to the console
                        echo output

                        // Log any SQL error messages
                        if (output.contains("Msg")) {
                            errorMessages.add(output)
                        }
                    }

                    // Send email if there are error messages
                    if (errorMessages) {
                        mailToNotify(errorMessages.join('\n'))
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

// Function to send email notification
def mailToNotify(String errorLog) {
    mail to: 'gcslsoftsupportblt3@globemw.net',
         subject: 'SQL Server Execution Notification',
         body: "The following errors were logged during SQL execution:\n\n${errorLog}"
}
