# -*- coding: utf-8 -*-

include_recipe 'nginx'

node['nginx_proxy']['proxies'].each do |site_name, options|
  options = case options
            when :apache, 'apache' then { apache: true }
            when String, Numeric then { port: options.to_i }
            else JSON[options.to_json] # json roundabout as a deep to_hash
            end
  nginx_proxy site_name do
    options.each do |option, value|
      send(option, value)
    end
  end
end
