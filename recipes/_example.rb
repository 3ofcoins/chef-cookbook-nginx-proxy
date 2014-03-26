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
