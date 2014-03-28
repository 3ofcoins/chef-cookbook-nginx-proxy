# -*- coding: utf-8 -*-

directory node['apache']['docroot_dir'] do
  recursive true
end

directory node['nginx']['default_root'] do
  recursive true
end

include_recipe 'apt'
include_recipe 'nginx-proxy'

# Need to alter the default sites to have them show what we want to
# see in the specs.

chef_gem 'chef-rewind'
require 'chef/rewind'

rewind 'template[/etc/nginx/sites-available/default]' do
  source 'nginx-default-site.erb'
  cookbook 'nginx-proxy-test'
end

rewind 'template[/etc/apache2/sites-available/default]' do
  source 'apache2-default-site.erb'
  cookbook 'nginx-proxy-test'
end

file "#{node['apache']['docroot_dir']}/index.html" do
  content "HELLO APACHE\n"
  mode 0644
end

file "#{node['nginx']['default_root']}/index.html" do
  content "HELLO NGINX\n"
  mode 0644
end
