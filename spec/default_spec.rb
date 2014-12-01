# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy::default' do
  before do
    stub_command('which nginx').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end
  let(:chef_run) { ChefSpec::SoloRunner.new }
  let(:proxies) { chef_run.node.set['nginx_proxy']['proxies'] }

  it 'should install nginx' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('nginx::default')
  end

  it 'creates proxy given a port as a number' do
    proxies['example.com'] = 8000
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:8000;'
  end

  it 'creates proxy given a port as string' do
    proxies['example.com'] = '8000'
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:8000;'
  end

  it 'creates proxy given an URL as string' do
    proxies['example.com'] =
      'http://example.info'
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://example.info;'
  end

  it 'creates proxy to apache' do
    proxies['example.com'] = 'apache'
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:81;'
  end

  it 'creates proxy to apache from keyword' do
    proxies['example.com'] = :apache
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:81;'
  end

  it 'creates proxy given a full spec' do
    proxies['example.com']['apache'] = true
    proxies['example.com']['ssl_key'] = 'example.com'
    proxies['example.com']['aka'] = [
      'old.example.com',
      ssl_key: 'old.example.com'
    ]
    chef_run.converge(described_recipe)
    expect_site 'example.com',
                'proxy_pass http://127.0.0.1:81;',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'
    expect_site 'old.example.com',
                'rewrite ^ https://example.com$request_uri? permanent;',
                'ssl_certificate_key /etc/ssl/private/old.example.com.key;'
  end

  it 'allows custom code snippets' do
    proxies['example.com']['apache'] = true
    proxies['example.com']['custom_config'] = 'client_max_body_size 100M;'
    chef_run.converge(described_recipe)
    expect_site 'example.com',
                'client_max_body_size 100M;'
  end
end
