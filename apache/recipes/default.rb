# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

package 'httpd'

service 'httpd' do
    action [:enable, :start]
end

file '/var/www/html/index.html' do
    content 'Welcome to your chef node'
end
