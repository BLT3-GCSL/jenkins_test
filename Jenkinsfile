pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                checkout scm
                script {
                    def scriptDirExists = fileExists('scripts')
                    if (scriptDirExists) {
                        echo "scripts folder found."

                        // List files in the scripts folder using PowerShell
                        powershell """
                            Get-ChildItem -Path 'scripts' -Force
                        """
                    } else {
                        error("scripts folder not found!")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // List the directory contents before searching for files
                    echo "Listing files in 'scripts' directory..."
                    powershell """
                        Get-ChildItem -Path 'scripts' -Force
                    """

                    // Use PowerShell to find all `.sql` files
                    def sqlFiles = powershell(returnStdout: true, script: """
                        Get-ChildItem -Path 'scripts' -Filter '*.sql' -File | ForEach-Object { $_.FullName }
                    """).trim().split('\r?\n')

                    // Output debug information
                    echo "Found SQL files: " + sqlFiles.join(', ')

                    // Check if any SQL files are found
                    if (sqlFiles.length == 0 || (sqlFiles[0] == "")) {
                        error("No SQL files found in the scripts folder.")
                    } else {
                        echo "${sqlFiles.length} SQL files found in the scripts folder."

                        // Validate that SQL files are named with numbers
                        def invalidFiles = []
                        sqlFiles.each { filePath ->
                            def fileName = filePath.split(/[\/\\]/).last()
                            if (!(fileName ==~ /^\d+\.sql$/)) {
                                invalidFiles.add(fileName)
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

                    def sqlScriptsDir = "scripts"
                    def sqlFiles = powershell(returnStdout: true, script: """
                        Get-ChildItem -Path 'scripts' -Filter '*.sql' -File | ForEach-Object { $_.FullName }
                    """).trim().split('\r?\n')

                    if (sqlFiles.length == 0 || (sqlFiles[0] == "")) {
                        error("No SQL scripts found for deployment.")
                    }

                    sqlFiles.each { filePath ->
                        def fileName = filePath.split(/[\/\\]/).last()
                        echo "Running SQL script: ${fileName}"

                        powershell """
                            sqlcmd -S ${server} -d ${database} -U ${username} -P ${password} -i '${filePath}'
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
