pipeline{
    agent any
    options{

    }
    parameters{
        activeChoiceParam('Regoin') {
                      description('Select your regoin')
                      choiceType('Filtered:List')
                      groovyScript {
                          script("
                            def aws_regions_output = 'aws ec2 describe-regions --all-regions --query "Regions[].{Name:RegionName}" --output text'.execute() | ['awk', '{ print $NF }'].execute()
                            def list = aws_regions_output.text.tokenize().reverse()
                            return list
                          ")
                          fallbackScript('return ["error"]')
                      }
                  }
    }
    stages{
        stage{
            steps{
                echo Hi
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