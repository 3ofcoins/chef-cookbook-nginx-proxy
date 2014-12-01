# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy/definitions/default.rb' do
  before do
    stub_command('which nginx').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end
  cached(:chef_run) { ChefSpec::SoloRunner.new.converge('nginx-proxy::_example') }

  it 'should include nginx-proxy and apache2' do
    expect(chef_run).to include_recipe('nginx-proxy::default')
    expect(chef_run).to include_recipe('nginx::default')
    expect(chef_run).to include_recipe('apache2::default')
  end

  it 'can just forward to a port' do
    expect_site 'trivial.example.com',
                'proxy_pass http://127.0.0.1:8000;',
                'server_name trivial.example.com'
  end

  it 'accepts explicitly set server_name' do
    expect_site 'server-name-property',
                'proxy_pass http://127.0.0.1:8000;',
                'server_name server-name-property.example.com;'
  end

  it 'accepts full target URL' do
    expect_site 'explicit-url.example.com',
                'proxy_pass https://1.2.3.4:8002;'
  end

  it 'can use apache as backend' do
    expect_site 'apache.example.com',
                'proxy_pass http://127.0.0.1:81;'
  end

  it 'can configure ssl by simple key name' do
    expect_site 'secure-by-name.example.com',
                'proxy_pass http://127.0.0.1:81;',
                'listen 443 ssl;',
                'ssl_certificate /etc/ssl/certs/example.pem;',
                'ssl_certificate_key /etc/ssl/private/example.key;'
  end

  it 'can also accept full path to key and certificate' do
    expect_site 'secure-by-path.example.com',
                'listen 443 ssl;',
                'ssl_certificate /path/to/certificate.pem;',
                'ssl_certificate_key /path/to/key.pem;'
  end

  it 'can do redirects' do
    expect_site 'redirect.example.com',
                'rewrite ^ https://target.example.com$request_uri? permanent;',
                'listen 443 ssl;',
                'ssl_certificate /etc/ssl/certs/example.com.pem;',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'
  end

  it 'can configure an alias for a host' do
    expect_site 'alias1.example.com',
                'rewrite ^ http://1alias.example.com$request_uri? permanent;'
  end

  it 'can configure multiple aliases' do
    expect_site 'alias2.example.com',
                'rewrite ^ http://2alias.example.com$request_uri? permanent;'

    expect_site 'alias3.example.com',
                'rewrite ^ http://2alias.example.com$request_uri? permanent;'
  end

  it 'can accept parameters for aliases' do
    expect_site 'salias.example.com',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'

    expect_site 'salias.i.example.com',
                'rewrite ^ https://salias.example.com$request_uri?',
                'listen 443 ssl;',
                'ssl_certificate_key /etc/ssl/private/i.example.com.key;'
  end
end
