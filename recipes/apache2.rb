# -*- coding: utf-8 -*-

include_recipe 'nginx-proxy'

node.override['apache']['listen_ports'] = [node['nginx_proxy']['apache_port']]
node.override['apache']['listen_addresses'] = %w(127.0.0.1)

include_recipe 'apache2'
