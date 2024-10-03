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

                    // Define the directory containing the SQL files (simplified glob pattern)
                    def scriptFiles = findFiles(glob: 'scripts/*.sql')
                    
                    // Output debug information
                    echo "Found files: " + scriptFiles.collect { it.path }.join(', ')

                    // Check if any SQL files are found
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
                    def server = 'AJSERVER' 
                    def database = 'TEST_DB' 
                    def username = 'sa' 
                    def password = 'Sa123'

                    def sqlScriptsDir = "scripts"
                    def sqlFiles = findFiles(glob: "${sqlScriptsDir}/*.sql")

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
