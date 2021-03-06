# -*- coding: utf-8 -*-

define :nginx_proxy, apache: false, redirect: false do
  include_recipe 'nginx-proxy::setup'
  params[:server_name] ||= params[:name]
  if params[:apache]
    fail 'apache specified with port or url' if params[:port] || params[:url]
    params[:url] = "http://127.0.0.1:#{node['nginx_proxy']['apache_port']}"
    include_recipe 'nginx-proxy::apache2'
  elsif params[:url] && params[:port]
    fail 'both port and url specified'
  end
  params[:url] ||= "http://127.0.0.1:#{params[:port]}"
  params[:redirect] = :permanent if params[:redirect] == true

  if params[:ssl_key]
    params[:ssl_key_path] ||= File.join(
      node['nginx_proxy']['ssl_key_dir'],
      "#{params[:ssl_key]}.key")
    params[:ssl_certificate_path] ||= File.join(
      node['nginx_proxy']['ssl_certificate_dir'],
      "#{params[:ssl_key]}.pem")
  end

  params[:access_control_allow_methods] = Array(params[:access_control_allow_methods] || 'GET')
  params[:access_control_allow_methods] |= %w'OPTIONS'

  nginx_site params[:name] do
    template params[:template] || 'nginx_site.conf.erb'
    cookbook params[:cookbook] || 'nginx-proxy'
    variables params
  end

  if params[:aka]
    params[:aka] = Array(params[:aka])
    aka_params = params[:aka].last.is_a?(Hash) ? params[:aka].pop : {}
    aka_params[:redirect] = true
    aka_params[:url] =
      "http#{'s' if params[:ssl_key_path]}://#{params[:server_name]}"

    params[:aka].each do |name|
      nginx_proxy(name) do
        aka_params.each do |k, v|
          send(k, v)
        end
      end
    end
  end
end
