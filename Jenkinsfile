pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                // Check out the repository using the SCM
                checkout scm

                // Check if the 'scripts' folder exists
                script {
                    def scriptDirExists = fileExists('scripts')
                    if (scriptDirExists) {
                        echo "scripts folder found."
                        
                        // Debug: List files in the scripts folder using PowerShell
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
                    // Debug: Check directory contents before searching for files
                    echo "Listing files in 'scripts' directory..."
                    powershell """
                        Get-ChildItem -Path 'scripts' -Force
                    """

                    // Define the directory containing the SQL files (case-insensitive)
                    def scriptFiles = findFiles(glob: 'scripts/(?i)*.sql')
                    
                    // Debug: Output the list of found SQL files
                    if (scriptFiles) {
                        echo "Found SQL files: " + scriptFiles.collect { it.name }.join(', ')
                    }

                    // Check if any SQL files are found in the scripts folder
                    if (scriptFiles.length == 0) {
                        error("No SQL files found in the scripts folder.")
                    } else {
                        echo "${scriptFiles.length} SQL files found in the scripts folder."
                        
                        // Validate that SQL files are named with numbers
                        def invalidFiles = []
                        scriptFiles.each { file ->
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
                    // Define the SQL Server connection details
                    def server = 'AJSERVER'
                    def database = 'TEST_DB'
                    def username = 'sa'
                    def password = 'Sa123'

                    // Define the directory containing the SQL files
                    def sqlScriptsDir = "scripts"

                    // Get a list of SQL files from the scripts directory (case-insensitive)
                    def sqlFiles = findFiles(glob: "${sqlScriptsDir}/(?i)*.sql")

                    if (sqlFiles.length == 0) {
                        error("No SQL scripts found for deployment.")
                    }

                    // Loop through each file and run it with sqlcmd using PowerShell
                    sqlFiles.each { file ->
                        def fileName = file.name  // Get the file name from the path
                        echo "Running SQL script: ${fileName}"

                        // Execute SQL script using sqlcmd in PowerShell
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
