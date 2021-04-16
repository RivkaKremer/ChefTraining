def DAY_TO_KEEP_STR = '2'

def NUM_TO_KEEP_STR = '20'

pipeline {
    agent any
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
        stage("Install ChefDK"){
            steps{
                script{
                    chefdkExist = fileExists '/usr/bin/chef-client'
                    if (chefdkExist){
                        echo 'Chef is already installed...'
                    }
                    else{
                        sh 'wget https://packages.chef.io/files/stable/chefdk/4.13.3/el/8/chefdk-4.13.3-1.el7.x86_64.rpm'
                        sh 'sudo yum -y install chefdk-4.13.3-1.el7.x86_64.rpm'
                    }
                    sh 'sudo /opt/chefdk/embedded/bin/gem install knife-ec2'
                }
            }
        }
        stage('Update Apache Html Content'){
            steps{
                script{
                    currentTime = sh(
                        script: "date '+%F %T'", 
                        returnStdout: true
                    ).trim()
                }
                sh "sed -i 's/<Place the content here>/Welcome ${params['User']}! The time now is: ${currentTime}/g' apache/recipes/default.rb"
                sh 'cat apache/recipes/default.rb'
            }
        }
        stage('Upload Cookbook To Chef Server'){
            steps{
                withCredentials([zip(credentialsId: 'chef-server-secret', variable: 'CHEFREPO')]){
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
                    sh 'mv $WORKSPACE/apache/* $CHEFREPO/chef-repo/cookbooks/apache'
                    dir("$CHEFREPO/chef-repo/cookbooks"){
                        sh 'knife cookbook upload apache'
                    }
                }
            }
        }
        stage('Update Role On Chef Server'){
            steps{
                withCredentials([zip(credentialsId: 'chef-server-secret', variable: 'CHEFREPO')]){
                    sh 'mv webserver_role.json $CHEFREPO/chef-repo/roles'
                    dir("$CHEFREPO/chef-repo/roles"){
                        sh 'knife role from file webserver_role.json'
                    }
                }
            }
        }
        stage('Boostrap Apache EC2 Node'){
            steps{
                withCredentials([zip(credentialsId: 'chef-server-secret', variable: 'CHEFREPO')]){
                    dir("$CHEFREPO/chef-repo/.chef"){
                        sh "sudo knife ec2 server create \
                        -I ami-0db9040eb3ab74509 -r \"role[webserver_role]\" \
                        -Z ${params['Region']}b -g sg-0ad135270a3c8bbed --ssh-key \
                        jenkins-slave -i ~/.ssh/jenkins-slave.pem -f t2.micro \
                        --region ${params['Region']} -U ec2-user --sudo \
                        --use-sudo-password --chef-license accept --yes"
                    }
                }
            }
        }
    }
    post{
        always{
            sh 'rm -f chef-16.13.16-1.el7.x86_64.rpm'
        }
    }
}