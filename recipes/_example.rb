# -*- coding: utf-8 -*-

# Examples for the nginx_proxy definition, used in specs

nginx_proxy 'trivial.example.com' do
  port 8000
end

nginx_proxy 'server-name-property' do
  server_name 'server-name-property.example.com'
  port 8000
end

nginx_proxy 'explicit-url.example.com' do
  url 'https://1.2.3.4:8002'
end

nginx_proxy 'apache.example.com' do
  apache
end

nginx_proxy 'secure-by-name.example.com' do
  apache true           # you can also explicitly provide a true value
  ssl_key 'example'
end

nginx_proxy 'secure-by-path.example.com' do
  apache
  ssl_key_path '/path/to/key.pem'
  ssl_certificate_path '/path/to/certificate.pem'
end

nginx_proxy 'redirect.example.com' do
  ssl_key 'example.com'
  url 'https://target.example.com'
  redirect true
end

nginx_proxy '1alias.example.com' do
  url 'http://example.com'
  aka 'alias1.example.com'
end

nginx_proxy '2alias.example.com' do
  aka 'alias2.example.com', 'alias3.example.com'
end

nginx_proxy 'salias.example.com' do
  ssl_key 'example.com'
  aka 'salias.i.example.com', ssl_key: 'i.example.com'
end
