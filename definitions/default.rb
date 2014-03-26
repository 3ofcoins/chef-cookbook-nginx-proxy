define :nginx_proxy,
       apache: false do
  include_recipe 'nginx-proxy'
  params[:server_name] ||= params[:name]
  params[:alias] = Array(params[:alias])
  if params[:apache]
    raise "apache specified with port or url" if params[:port] || params[:url]
    params[:url] = "http://127.0.0.1:#{node['nginx_proxy']['apache_port']}"
  elsif params[:url] && params[:port]
    raise "both port and url specified"
  end
  params[:url] ||= "http://127.0.0.1:#{params[:port]}"

  if params[:ssl_key]
    params[:ssl_key_path] ||= File.join(node['nginx_proxy']['ssl_key_dir'], "#{params[:ssl_key]}.key")
    params[:ssl_certificate_path] ||= File.join(node['nginx_proxy']['ssl_certificate_dir'], "#{params[:ssl_key]}.pem")
  end

  template "#{node['nginx']['dir']}/sites-available/#{params[:name]}" do
    source 'nginx_site.conf.erb'
    variables params
    notifies :reload, 'service[nginx]'
  end

  nginx_site params[:name]
end
