def DAY_TO_KEEP_STR = '2'

def NUM_TO_KEEP_STR = '20'

def groovyTool

properties([
    parameters([
        [
            $class: 'ChoiceParameter', 
            choiceType: 'PT_SINGLE_SELECT', 
            description: 'Select a region', 
            filterLength: 1, 
            filterable: true, 
            name: 'choice1', 
            randomName: 'choice-parameter-7601235200970', 
            script: [
                $class: 'GroovyScript', 
                fallbackScript: [classpath: [], 
                sandbox: false, 
                script: 'return ["ERROR"]'], 
                script: [
                    classpath: [], 
                    sandbox: false, 
                    script: "return ('aws ec2 describe-regions --all-regions --query Regions[].{Name:RegionName} --output text'.execute() | ['awk', '{ print $NF }'].execute()).text.tokenize().reverse()"
                ]
            ]        
        ]
           
    ])   
])

Permalink
pkb12345


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