def DAY_TO_KEEP_STR = '2'

def NUM_TO_KEEP_STR = '20'

def groovyTool

// properties([
//     parameters([
//         [
//             $class: 'ChoiceParameter', 
//             choiceType: 'PT_SINGLE_SELECT', 
//             description: 'Select a region', 
//             filterLength: 1, 
//             filterable: true, 
//             name: 'choice1', 
//             randomName: 'choice-parameter-7601235200970', 
//             script: [
//                 $class: 'GroovyScript', 
//                 fallbackScript: [classpath: [], sandbox: false, script: 'return ["ERROR"]'], 
//                 script: [
//                     classpath: [], 
//                     sandbox: false, 
//                     script: "return ('aws ec2 describe-regions --all-regions --query Regions[].{Name:RegionName} --output text'.execute().text.tokenize().reverse())"
//                 ]
//             ]        
//         ]
           
//     ])   
// ])


pipeline {
    agent {
        docker {
            reuseNode false
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
            image 'chef/chefdk'
        }
    }
    options{
        buildDiscarder(logRotator(daysToKeepStr: DAY_TO_KEEP_STR, numToKeepStr: NUM_TO_KEEP_STR))
        timestamps()
    }
    parameters{
        string(
            name: 'User', defaultValue: '', description: "Fill in a user name to be displayed on servers index.html page"
        )
        string(
            name: 'Region', defaultValue: '', description: "Choose a region"
        )
    }
    stages{
        stage('Dependencies for Docker and ChefDK') {
            steps {
                sh '''
                apt-get update
                apt-get install -y sudo git build-essential apt-transport-https ca-certificates curl software-properties-common
                '''
            }
        }
        stage(']Install Docker-CE') {
            steps {
                sh '''
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                apt-get update
                apt-get install -y docker-ce
                '''
            }
        }
        stage('Start Docker') {
            steps {
                sh 'service docker start'
            }
        }
        stage('Verify Docker') {
            steps {
                sh 'docker run --rm hello-world'
            }
        }
        stage('Verify ChefDK') {
            steps {
                sh '''
                /opt/chefdk/embedded/bin/chef --version
                /opt/chefdk/embedded/bin/cookstyle --version
                /opt/chefdk/embedded/bin/foodcritic --version
                '''
            }
        }
        stage('Verify Kitchen') {
            steps { sh 'KITCHEN_LOCAL_YAML=.kitchen.dokken.yml /opt/chefdk/embedded/bin/kitchen list'
            }
        }
        stage('Run test-kitchen') { 
            steps {
                sh '''KITCHEN_LOCAL_YAML=.kitchen.dokken.yml /opt/chefdk/embedded/bin/kitchen test centos'''
            }
        }
        stage('Upload to Chef Server') {
            steps { 
                sh 'chef exec knife cookbook upload COOKBOOKNAME -o ../'
            }
        }
    }
}