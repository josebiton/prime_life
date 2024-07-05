ipipeline {
    agent any
    
    stages {
        stage('Preparacion') {
            steps {
                git branch: 'main', url: 'https://github.com/josebiton/prime_life.git'
                echo 'Pulled from GitHub successfully'
            }
        }

        stage('Verifica version php') {
            steps {
                sh 'php --version'
            }
        }

        

        stage('Compilación de Docker') {
            steps {
                sh 'docker build -t primelife .'
            }
        }

        stage('Implementar php') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}
