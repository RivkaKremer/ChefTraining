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
        stage("Install ChefDK & Ruby"){
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
                    // sh 'sudo yum install -y curl gpg gcc gcc-c++ make'
                    // sh '''
                    //     sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
                    //     curl -sSL https://get.rvm.io | sudo bash -s stable
                    //     sudo usermod -a -G rvm `whoami`
                    // '''
                    sh 'sudo yum install ruby23'
                    sh 'sudo gem install knife-ec2'
                }
            }
        }
        stage('Upload Cookbook To Chef Server'){
            steps{
                withCredentials([zip(credentialsId: 'chef-server-secret', variable: 'CHEFREPO')]){
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookcooks/apache'
                    sh 'mv $WORKSPACE/apache/* $CHEFREPO/chef-repo/cookcooks/apache'
                    sh 'knife cookbook upload apache'
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