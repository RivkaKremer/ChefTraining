def DAY_TO_KEEP_STR = '2'

def NUM_TO_KEEP_STR = '20'

def groovyTool

pipeline{
    agent any
    options{
        buildDiscarder(logRotator(daysToKeepStr: DAY_TO_KEEP_STR, numToKeepStr: NUM_TO_KEEP_STR))
        timestamps()
    }
    parameters{
        string(
            name: 'User', defaultValue: '', description: "Fill in a user name to be displayed on servers index.html page"
        )
        activeChoiceParam('Regoin') {
                      description('Select your regoin')
                      choiceType('Filtered:List')
                      groovyScript {
                          script(" return ('aws ec2 describe-regions --all-regions --query "Regions[].{Name:RegionName}" --output text'.execute() | ['awk', '{ print $NF }'].execute()).text.tokenize().reverse()")
                          fallbackScript('return ["error"]')
                      }
                  }
    }
    stages{
        stage("Initialization"){
            steps{
                script{
                    groovyTool = load "${env.WORKSPACE}/buildTool.groovy"
                    tool.installChef()
                }
            }
        }
    }
    post{
        always{
            steps{
                echo post
            }
        }
    }
}