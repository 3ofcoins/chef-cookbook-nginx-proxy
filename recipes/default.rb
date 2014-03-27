# -*- coding: utf-8 -*-

include_recipe 'nginx-proxy::setup'

node['nginx_proxy']['proxies'].each do |site_name, options|
  options = case options
            when :apache, 'apache' then { apache: true }
            when /^\d+$/, Numeric then { port: options.to_i }
            when String then { url: options }
            else JSON[options.to_json] # json roundabout as a deep to_hash
            end
  nginx_proxy site_name do
    options.each do |option, value|
      send(option, value)
    end
  end
end
