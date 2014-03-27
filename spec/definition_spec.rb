# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy/definitions/default.rb' do
  let(:chef_run) { ChefSpec::Runner.new }

  it 'should install nginx' do
    chef_run.converge('apache2', 'nginx-proxy::_example')
    expect(chef_run).to include_recipe('nginx-proxy::default')

    expect_site 'trivial.example.com',
                'proxy_pass http://127.0.0.1:8000;',
                'server_name trivial.example.com'

    expect_site 'server-name-property',
                'proxy_pass http://127.0.0.1:8000;',
                'server_name server-name-property.example.com;'

    expect_site 'explicit-url.example.com',
                'proxy_pass https://1.2.3.4:8002;'

    expect_site 'apache.example.com',
                'proxy_pass http://127.0.0.1:81;'

    expect_site 'secure-by-name.example.com',
                'proxy_pass http://127.0.0.1:81;',
                'listen 443 ssl;',
                'ssl_certificate /etc/ssl/certs/example.pem;',
                'ssl_certificate_key /etc/ssl/private/example.key;'

    expect_site 'secure-by-path.example.com',
                'listen 443 ssl;',
                'ssl_certificate /path/to/certificate.pem;',
                'ssl_certificate_key /path/to/key.pem;'

    expect_site 'redirect.example.com',
                'rewrite ^ https://target.example.com$request_uri? permanent;',
                'listen 443 ssl;',
                'ssl_certificate /etc/ssl/certs/example.com.pem;',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'

    expect_site 'alias1.example.com',
                'rewrite ^ http://1alias.example.com$request_uri? permanent;'

    expect_site 'alias2.example.com',
                'rewrite ^ http://2alias.example.com$request_uri? permanent;'

    expect_site 'alias3.example.com',
                'rewrite ^ http://2alias.example.com$request_uri? permanent;'

    expect_site 'salias.example.com',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'

    expect_site 'salias1.example.com',
                'rewrite ^ https://salias.example.com$request_uri? permanent;',
                'listen 443 ssl;',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'

    expect_site 'salias-i.example.com',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'

    expect_site 'salias.i.example.com',
                'rewrite ^ https://salias-i.example.com$request_uri? permanent;',
                'listen 443 ssl;',
                'ssl_certificate_key /etc/ssl/private/i.example.com.key;'
  end
end
