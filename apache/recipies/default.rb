# Cookbook:: apache
# Recipe:: default

package 'apache2'

file '/var/www/html/index.html' do
    content "<h2>This is #{node['name']}</h2><h1>Hello</h1>"
end

service 'apache2' do
    sction [ :enable, : start]
end
