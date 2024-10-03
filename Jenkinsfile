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
                    } else {
                        error("scripts folder not found!")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Define the directory containing the SQL files
                    def scriptFiles = findFiles(glob: 'scripts/*.sql')
                    
                    // Check if any SQL files are found in the scripts folder
                    if (scriptFiles.length == 0) {
                        error("No SQL files found in the scripts folder.")
                    } else {
                        echo "${scriptFiles.length} SQL files found in the scripts folder."
                        
                        // Validate that SQL files are named with numbers
                        def invalidFiles = []
                        scriptFiles.each { file ->
                            if (!file.name ==~ /^\d+\.sql$/) {
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

                    // Get a list of SQL files from the scripts directory
                    def sqlFiles = findFiles(glob: "${sqlScriptsDir}/*.sql")

                    if (sqlFiles.length == 0) {
                        error("No SQL scripts found for deployment.")
                    }

                    // Loop through each file and run it with sqlcmd
                    sqlFiles.each { file ->
                        def fileName = file.name  // Get the file name from the path
                        echo "Running SQL script: ${fileName}"

                        // Execute SQL script using sqlcmd
                        sh """
                            sqlcmd -S ${server} -d ${database} -U ${username} -P ${password} -i ${file.path}
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
