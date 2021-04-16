# ChefTraining

##First I raised a chef server (hosted) and installed the workstation on the jenkins EC2 Linux slave</br>

##Then the pipeline does:</br>

###stage 'Install ChefDK':</br>
    1. install chefdk - if not exists</br>
    2. install knife ec2 plugin</br>
        
###stage 'Update Apache Html Content':</br>
    Update the content of index.html page in the apache recipe with the 
    value provided by the user as a parameter</br>
            
###stage 'Upload Cookbook To Chef Server':</br>
    1. copy the cookbook files from the local repository into the chef 
       server's starter-kit cookbooks folder 
       the starter kit is saved encripted in jenkins credentiald store
       and is not located phisicaly on on the disc, but virtually, 
       so it is kept safe.</br>
                   
    2. upload/update the cookbook to chef server.
 </br>

###stage 'Update Role On Chef Server': </br>
    1. I copy the role json file from local repo into the
       chef server's starter-kit roles folder </br>
    2. create.upload webser_role in chef server </br>
       
###stage 'Boostrap Apache EC2 Node': </br>
    1. I used knife-ec2 plugin to create an ec2 Amazon linux server.
       The region was chosen bythe user.
       The role installs and configures apache recipe on the server, with the modified content in the index.html file. </br>
                    