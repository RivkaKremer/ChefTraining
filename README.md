# ChefTraining
First I 

This pipeline staged do:

 stage 'Install ChefDK':
    1. install chefdk - if not exists
    2. install knife ec2 plugin
        
stage 'Update Apache Html Content':
    Update the content of index.html page in the apache recipe with the value provided by the user as a parameter
            
stage 'Upload Cookbook To Chef Server':
    1. copy the cookbook files from the local repository into the chef 
        server's starter-kit cookbooks folder 
        the starter kit is saved encripted in jenkins credentiald store
        and is not located phisicaly on on the disc, but virtually, so it is kept save.
                   
    2. upload/update the cookbook to chef server
                    dir("$CHEFREPO/chef-repo/cookbooks"){

stage 'Update Role On Chef Server':
            steps{
    1. I copy the role json file from local repo into the
       chef server's starter-kit roles folder
    2. create.upload webser_role in chef server
       
stage 'Boostrap Apache EC2 Node':
    1. I used knife-ec2 plugin to create an ec2 Amazon linux server.
       The region was chosen bythe user.
       The role installs and configures apache recipe on the server, with the modified content in the index.html file.
                    